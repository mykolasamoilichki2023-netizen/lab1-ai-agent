---
name: build-and-test
description: "Застосовуйте для npm scripts, TypeScript і Vitest конфігурації, тесту BasicAddition, package-lock.json та кросплатформних скриптів ci.sh/ci.bat."
---

# Build and Test

## Коли застосовувати

Застосовуй після `project-scaffold`, коли `src/hello.ts` і початковий README вже існують та потрібно налаштувати складання, unit-тестування й локальні CI-скрипти для TypeScript.

## Вхідні дані

- Структура проєкту з `src/hello.ts`, каталогами `src/` і `tests/`.
- Доступні `node` і `npm`; мережевий доступ npm потрібен для встановлення залежностей і створення lock-файлу.
- Наявні `package.json`, `package-lock.json` та конфігурації, якщо вони вже були створені.

Якщо вихідний файл відсутній або `node`/`npm` недоступні, зупинись і повідом про передумову, якої бракує.

## Що створює

- `src/math.ts` із функцією `add(a: number, b: number): number`.
- `tests/BasicAddition.test.ts` на Vitest: `describe("BasicAddition")`, перевірка `add(2, 3) === 5` і щонайменше ще один випадок.
- `package.json` з `"type": "module"`, `typescript` і `vitest` у `devDependencies`, та scripts:
  - `build`: `tsc`
  - `test`: `vitest run`
  - `start`: `node dist/hello.js`
  - `ci`: `npm run build && npm test`
- `tsconfig.json`: `target: ES2022`, `module: NodeNext`, `moduleResolution: NodeNext`, `strict: true`, `rootDir: src`, `outDir: dist`, `include` лише для `src`; тести не компілюються до `dist/`.
- `vitest.config.ts` із `include: ['tests/**/*.test.ts']`.
- `package-lock.json`, створений командою `npm install`; файл має залишатися в репозиторії й не потрапляти до `.gitignore`.
- `scripts/ci.sh` із shebang `#!/usr/bin/env bash`, `set -euo pipefail`, командами `npm ci`, `npm run build`, `npm test`, перевіркою `dist/hello.js` і запуском `node dist/hello.js`.
- `scripts/ci.bat` з тими самими кроками. Кожну npm-команду викликай через `call`; після кожного кроку перевіряй `if errorlevel 1 exit /b 1`.
- `.gitattributes` із правилами `*.sh text eol=lf` і `*.bat text eol=crlf`.

Імпорти між файлами у `src/` пиши з розширенням `.js`, сумісним із NodeNext, наприклад `import { add } from './math.js'`.

## Кроки

1. Перевір, що `src/hello.ts` існує, а також прочитай наявні файли цього етапу перед зміною.
2. Створи або онови `src/math.ts` і тест, зберігши інші наявні тести.
3. Злий потрібні поля та scripts у наявний `package.json`, не видаляючи сторонніх залежностей чи scripts. Встанови `typescript` і `vitest` як devDependencies.
4. Створи або онови `tsconfig.json` так, щоб компілятор включав лише `src` і не виводив тести до `dist/`. Налаштуй Vitest на вказаний glob.
5. Створи або онови `scripts/ci.sh` і `scripts/ci.bat`. В обох скриптах явно перевір існування `dist/hello.js` перед запуском. У batch-файлі перевіряй код завершення після кожного кроку.
6. Забезпеч потрібні рядки у `.gitattributes`, не дублюючи їх і зберігаючи інші атрибути.
7. Після редагування `package.json` виконай `npm install`, щоб згенерувати або синхронізувати `package-lock.json`. Не видаляй і не ігноруй lock-файл.
8. Виконай усі перевірки нижче. Якщо будь-яка завершується помилкою, зупинись за правилами обробки помилок.

Усі дії ідемпотентні: спочатку перевіряй існування й читай файл; оновлюй лише потрібні поля, scripts або рядки; не додавай вдруге тест, залежність, script чи атрибут.

## Перевірки

Запускай із кореня репозиторію:

```powershell
npm install
npm ci
npm run build
npm test
node dist/hello.js
Test-Path dist/hello.js -PathType Leaf
```

Переконайся, що `npm test` показує успішний `BasicAddition`, а `node dist/hello.js` виводить `Hello World`. На Windows додатково запусти скрипт і перевір код завершення:

```powershell
scripts\ci.bat
if ($LASTEXITCODE -ne 0) { throw "scripts\ci.bat exited with code $LASTEXITCODE" }
```

Перевір наявність lock-файлу та потрібних атрибутів:

```powershell
Test-Path package-lock.json -PathType Leaf
$attrs = Get-Content .gitattributes; foreach ($entry in @('*.sh text eol=lf', '*.bat text eol=crlf')) { if (@($attrs | Where-Object { $_ -ceq $entry }).Count -ne 1) { throw "Expected exactly one .gitattributes entry: $entry" } }
```

У `tsconfig.json` звір, що `include` обмежений `src`, а в `package.json` присутні всі чотири scripts та `"type": "module"`.

## Обробка помилок

За першої помилки зупинись. Укажи етап, точну команду, код завершення й повний текст помилки; не переходь до workflow. Якщо lock-файл застарів після зміни залежностей, не приховуй проблему — повідом, що `npm install` має синхронізувати його, а потім повтори перевірки лише за інструкцією користувача. Не повідомляй про успіх команд, яких не запускав.

## Приклад входу

```text
Налаштуй складання й тести для TypeScript Hello World. Додай add() та BasicAddition із перевірками 2 + 3 = 5 і 0 + 0 = 0.
```

## Очікуваний результат

`npm ci`, `npm run build`, `npm test` і `node dist/hello.js` проходять; тест `BasicAddition` зелений, Hello World з'являється у виводі, `dist/hello.js` існує. На Windows `scripts\ci.bat` завершується з кодом 0. `package-lock.json` присутній, а `.gitattributes` визначає LF для `.sh` і CRLF для `.bat`.

## Типовий сценарій помилки

- **Симптом:** `npm ci` завершується помилкою про невідповідність lock-файлу залежностям.
- **Причина:** `package.json` змінився, а `package-lock.json` не був синхронізований.
- **Виправлення:** виконай `npm install`, перевір, що `package-lock.json` оновлено і не ігнорується Git, потім повтори `npm ci` та інші перевірки.