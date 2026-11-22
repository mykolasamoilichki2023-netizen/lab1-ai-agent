---
agent: build-engineer
description: "Оркеструє повну ініціалізацію проєкту, послідовно викликає prompts і завершує лише з PASS від check."
---

# Ініціалізація проєкту

## Передумови

Працюй із кореня репозиторію. Перевір доступність `node`, `npm` і `git` командами `node --version`, `npm --version`, `git --version`. Якщо будь-яка команда недоступна, зупинись до змін. Передай усім етапам назву проєкту `hello` і мову `TypeScript`.

## Дії

1. Послідовно виконай інструкції prompt files:
   - [git-init](./git-init.prompt.md)
   - [create-project](./create-project.prompt.md)
   - [create-build](./create-build.prompt.md)
   - [create-actions](./create-actions.prompt.md)
   - [check](./check.prompt.md)
2. Після кожного успішного етапу передай наступному назву проєкту `hello`, мову `TypeScript`, перелік створених або оновлених файлів і результат попередньої перевірки.
3. На першій помилці негайно зупинись і не запускай наступні етапи. Звітуй про етап, команду, точний текст помилки та пропозицію виправити інструкції відповідного skill або prompt.
4. Наприкінці наведи результати всіх етапів і повну таблицю з `check`. Не вважай роботу успішною без підсумкового `PASS` від `check`.
5. Усі етапи мають бути ідемпотентними; не виконуй `git commit` або `git push`.

## Очікувані файли

Агрегований очікуваний результат: `src/hello.ts`, `src/math.ts`, `tests/BasicAddition.test.ts`, `package.json`, `package-lock.json`, `tsconfig.json`, `vitest.config.ts`, `scripts/ci.sh`, `scripts/ci.bat`, `.gitattributes`, `.gitignore`, `.github/workflows/ci.yml`, `README.md` і `docs/usage.md`.

## Команди перевірки

```powershell
node --version
npm --version
git --version
```

Перевірки проєкту виконуй через зазначені вище prompt files. Не пропускай етап і не замінюй результат `/check` власним припущенням.

## Повідомлення про помилку

При першій помилці припини оркестрацію. Поверни назву етапу, точну команду, текст помилки та конкретну пропозицію виправити інструкції. Познач усі наступні етапи як невиконані; підсумковий статус — `FAIL`, якщо `/check` не завершився з `PASS`.