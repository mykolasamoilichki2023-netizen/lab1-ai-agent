---
agent: build-engineer
description: "Налаштовує npm, TypeScript, Vitest і кросплатформні локальні скрипти складання та перевіряє їх."
---

# Створення складання й тестів

## Передумови

Працюй із кореня репозиторію після успішного `/create-project`. Прочитай і виконай [build-and-test](../skills/build-and-test/SKILL.md); перевір наявність `src/hello.ts`.

## Дії

1. Ідемпотентно створи або онови файли згідно з skill, зберігаючи сторонні поля, scripts, залежності й тести.
2. Після створення та оновлення файлів виконай `npm install`, `npm run build`, `npm test` саме в такому порядку.
3. Не переходь до `/create-actions`, якщо будь-яка команда завершується помилкою.
4. Не виконуй `git commit` або `git push`.

## Очікувані файли

- `src/math.ts`, `tests/BasicAddition.test.ts`, `package.json`, `package-lock.json`.
- `tsconfig.json`, `vitest.config.ts`, `scripts/ci.sh`, `scripts/ci.bat`, `.gitattributes`.

## Команди перевірки

```powershell
npm install
npm run build
npm test
```

Звір зелений тест `BasicAddition` і фактичний код завершення кожної команди. Додаткові перевірки описані в [build-and-test](../skills/build-and-test/SKILL.md); не заявляй про результат, якого не отримав.

## Повідомлення про помилку

Зупинись при першій помилці. Повідом етап, виконану команду, код завершення і точний текст помилки; не запускай наступний етап і запропонуй виправити інструкції skill.