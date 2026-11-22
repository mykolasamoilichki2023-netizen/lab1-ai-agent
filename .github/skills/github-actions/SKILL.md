---
name: github-actions
description: "Застосовуйте для створення та перевірки GitHub Actions CI workflow із матрицею Windows, Linux і macOS, який запускає готові ci.sh та ci.bat."
---

# GitHub Actions

## Коли застосовувати

Застосовуй після створення локальних скриптів `scripts/ci.sh` і `scripts/ci.bat`, коли потрібно налаштувати автоматичні перевірки під час push і pull request до `develop` або `master`, а також запуск вручну.

## Вхідні дані

- Репозиторій із `scripts/ci.sh` і `scripts/ci.bat`.
- GitHub Actions runner-и `ubuntu-latest`, `windows-latest` і `macos-latest`.
- Node.js 24 та npm lock-файл для кешування залежностей через `actions/setup-node`.

Якщо локальні скрипти відсутні, спочатку заверши `build-and-test`; не створюй альтернативні команди CI у workflow.

## Що створює

- `.github/workflows/ci.yml` з назвою workflow `CI`.
- Тригери `push` і `pull_request` для гілок `develop` та `master`, а також `workflow_dispatch`.
- Job `build` із `strategy.fail-fast: false` і матрицею `ubuntu-latest`, `windows-latest`, `macos-latest`.
- Кроки `actions/checkout@v5`, `actions/setup-node@v5` із `node-version: 24` та `cache: npm`, а потім лише запуск локального скрипта: на Windows `scripts\ci.bat` через `shell: cmd`, на Linux/macOS `bash scripts/ci.sh`.

У `ci.yml` заборонено дублювати npm-команди або самостійно виконувати складання й тести: усі ці дії належать `ci.sh` і `ci.bat`.

## Кроки

1. Перевір наявність обох CI-скриптів і прочитай поточний `.github/workflows/ci.yml`, якщо він уже існує.
2. Створи каталог workflow лише за потреби. Створи файл або точково онови наявний workflow, зберігши інші workflow-файли та непов'язані налаштування.
3. Визнач workflow name, тригери, гілки, job `build`, матрицю трьох ОС і `fail-fast: false` відповідно до специфікації.
4. Додай checkout і setup-node з Node.js 24 та npm cache.
5. Додай умовні кроки запуску: Windows використовує `shell: cmd` і `scripts\ci.bat`; інші ОС використовують `bash scripts/ci.sh`.
6. Перевір, що після setup-node workflow лише викликає скрипт для відповідної ОС і не містить npm-команд.
7. Запусти перевірки нижче; дочекайся результату до повідомлення про завершення.

Усі кроки ідемпотентні: перед створенням перевіряй файл; якщо він існує, прочитай і онови тільки потрібну workflow-конфігурацію. Не додавай вдруге тригери, jobs або кроки та не перезаписуй сторонні workflow.

## Перевірки

Із кореня репозиторію виконай структурну перевірку GitHub Actions, якщо `actionlint` доступний:

```powershell
actionlint .github/workflows/ci.yml
```

Переконайся, що у файлі є всі runner-и, обидва тригери з гілками, `workflow_dispatch`, `fail-fast: false`, checkout@v5 і setup-node@v5 з Node.js 24 та npm cache. Перевір відсутність npm-команд безпосередньо у workflow:

```powershell
Select-String -Path .github/workflows/ci.yml -Pattern '\bnpm\s+(ci|install|run|test|build)\b'
```

Для останньої команди очікується відсутність збігів. Якщо `actionlint` не встановлено, чітко вкажи, що автоматична перевірка YAML/workflow не виконана; не оголошуй її успішною. За можливості перевір запуск матриці через GitHub Actions після push відповідно до дозволів користувача.

## Обробка помилок

Зупинись на першій помилці та повідом точний етап, команду й текст помилки. Якщо workflow структурно некоректний або локальний скрипт відсутній, не додавай inline npm-команди як обхідний шлях; вкажи, які інструкції чи попередній етап потрібно виправити. Не заявляй про успішний CI без фактичного результату runner-ів.

## Приклад входу

```text
Створи CI workflow для develop і master на Ubuntu, Windows та macOS, який запускає наявні scripts/ci.sh і scripts/ci.bat.
```

## Очікуваний результат

`.github/workflows/ci.yml` має коректний YAML, зрозумілий job `build`, три ОС, `fail-fast: false`, зазначені тригери й потрібні actions. Після setup-node кожен runner запускає лише свій скрипт; npm-команд у workflow немає.

## Типовий сценарій помилки

- **Симптом:** Windows job не знаходить або не може запустити `scripts\ci.bat`.
- **Причина:** крок використовує shell за замовчуванням замість `cmd` або шлях має неправильні роздільники.
- **Виправлення:** задай для Windows-кроку `if: runner.os == 'Windows'`, `shell: cmd` і `run: scripts\ci.bat`; для Linux/macOS залиш окремий крок `bash scripts/ci.sh`.