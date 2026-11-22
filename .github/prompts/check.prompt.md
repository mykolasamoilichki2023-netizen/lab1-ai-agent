---
agent: build-engineer
description: "Перевіряє проєкт, локальні CI-скрипти й GitHub Actions без редагування вихідних файлів та формує таблицю PASS/FAIL."
---

# Перевірка проєкту

## Передумови

Працюй із кореня репозиторію після створення проєкту. Дотримуйся перевірок [project-scaffold](../skills/project-scaffold/SKILL.md), [build-and-test](../skills/build-and-test/SKILL.md) і [github-actions](../skills/github-actions/SKILL.md). Цей prompt не редагує файли; `npm ci` та збірка можуть створити лише генеровані залежності й артефакти.

## Дії

1. Перевір наявність кожного очікуваного файлу наведеним нижче списком.
2. Перевір `.gitignore` на `dist/` і `node_modules/`, а `git status` — що ці каталоги не позначені як нові файли.
3. Виконай `npm ci`, `npm run build` і `npm test`; у результаті тестів підтвердь проходження `BasicAddition`.
4. Запусти `node dist/hello.js` і переконайся, що вивід містить `Hello World`.
5. Розбери workflow командою `npx --yes js-yaml .github/workflows/ci.yml`; перевір три runner-и та відсутність npm-команд у workflow.
6. Для кожної перевірки зафіксуй `PASS` або `FAIL` і деталі. Підсумок `PASS` дозволений лише тоді, коли всі рядки таблиці мають статус `PASS`.
7. Не змінюй source, конфігурації, документацію чи інші файли; не коміть і не відправляй зміни.

## Очікувані файли

Перевір наявність усіх файлів:

`src/hello.ts`, `src/math.ts`, `tests/BasicAddition.test.ts`, `package.json`, `package-lock.json`, `tsconfig.json`, `vitest.config.ts`, `scripts/ci.sh`, `scripts/ci.bat`, `.gitattributes`, `.gitignore`, `.github/workflows/ci.yml`, `docs/usage.md`.

## Команди перевірки

```powershell
$expected = @('src/hello.ts', 'src/math.ts', 'tests/BasicAddition.test.ts', 'package.json', 'package-lock.json', 'tsconfig.json', 'vitest.config.ts', 'scripts/ci.sh', 'scripts/ci.bat', '.gitattributes', '.gitignore', '.github/workflows/ci.yml', 'docs/usage.md'); foreach ($path in $expected) { if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Missing expected file: $path" } }
Select-String -Path .gitignore -Pattern '^(dist/|node_modules/)$'
git status --short --untracked-files=all
npm ci
npm run build
$testOutput = npm test 2>&1; $testExit = $LASTEXITCODE; $testOutput; if ($testExit -ne 0 -or (($testOutput | Out-String) -notmatch 'BasicAddition')) { throw 'BasicAddition did not pass or npm test failed' }
$helloOutput = node dist/hello.js; $helloOutput; if ($LASTEXITCODE -ne 0 -or (($helloOutput | Out-String) -notmatch 'Hello World')) { throw 'Expected Hello World from dist/hello.js' }
npx --yes js-yaml .github/workflows/ci.yml
Select-String -Path .github/workflows/ci.yml -Pattern 'ubuntu-latest', 'windows-latest', 'macos-latest'
Select-String -Path .github/workflows/ci.yml -Pattern '\bnpm\s+(ci|install|run|test|build)\b'
```

Для `git status` перевір, що немає untracked-шляхів `dist/` чи `node_modules/`; за потреби відфільтруй результат через `Where-Object { $_ -match '^\?\?.*(dist[/\\]|node_modules[/\\])' }` і познач FAIL, якщо знайдено збіги. Відсутність npm-команд у `ci.yml` також означає відсутність збігів у відповідному `Select-String`.

Поверни таблицю такого формату:

| перевірка | команда | статус PASS/FAIL | деталі |
|---|---|---|---|
| Очікувані файли | `Test-Path` для кожного шляху | PASS або FAIL | Перелік відсутніх файлів або підтвердження наявності |

Додай окремий рядок для кожної перевірки й загальний підсумок. Не позначай пропущену чи невдалу перевірку як `PASS`.

## Повідомлення про помилку

Не приховуй помилки команд: зафіксуй їх як `FAIL` разом із командою та текстом. Продовжуй незалежні read-only перевірки, якщо це можливо; якщо помилка блокує залежні кроки, познач їх `FAIL` як пропущені через залежність. Підсумок має бути `FAIL`, щойно будь-який пункт не пройшов.