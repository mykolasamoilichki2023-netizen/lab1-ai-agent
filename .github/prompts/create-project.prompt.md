---
agent: build-engineer
description: "Створює основу проєкту hello мовою TypeScript і документацію для запуску агента та локальних перевірок."
---

# Створення проєкту

## Передумови

Працюй із кореня Git-репозиторію після успішного `/git-init`. Назва проєкту — `hello`, мова — TypeScript. Дотримуйся [project-scaffold](../skills/project-scaffold/SKILL.md).

## Дії

1. Виклич skill `project-scaffold` із параметрами: назва `hello`, мова `TypeScript`.
2. Ідемпотентно створи або доповни `docs/usage.md`, попередньо перевіривши й прочитавши файл, якщо він існує. Збережи інший його вміст і не дублюй розділи чи команди.
3. У `docs/usage.md` зазнач команди запуску агента `/lab-init` і `/check`, а також локальної перевірки: `npm ci`, `npm run build`, `npm test`, `node dist/hello.js`, `scripts\ci.bat` або `bash scripts/ci.sh`.
4. Не створюй тестів, конфігурації складання чи CI workflow на цьому етапі.

## Очікувані файли

- `src/hello.ts`, каталоги `src/` і `tests/`, `README.md`, `.gitignore` — за контрактом skill.
- `docs/usage.md` із командами агента й локальної перевірки.

## Команди перевірки

```powershell
Test-Path src/hello.ts -PathType Leaf
Select-String -Path src/hello.ts -SimpleMatch 'Hello World'
Select-String -Path README.md -SimpleMatch 'npm run start'
Select-String -Path docs/usage.md -SimpleMatch '/lab-init', '/check', 'npm ci', 'npm run build', 'npm test', 'node dist/hello.js', 'scripts\ci.bat', 'bash scripts/ci.sh'
```

Повтори перевірку наявності рядків `.gitignore` згідно з [project-scaffold](../skills/project-scaffold/SKILL.md). Не запускай складання чи тести до `/create-build`.

## Повідомлення про помилку

При першій помилці зупинись. Вкажи етап, команду й точний текст помилки; не переходь до наступного prompt і запропонуй виправити відповідні інструкції.