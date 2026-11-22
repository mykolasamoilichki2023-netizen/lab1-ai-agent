---
agent: build-engineer
description: "Перевіряє Git-репозиторій, ідемпотентно оновлює .gitignore та показує стан Git."
---

# Ініціалізація Git

## Передумови

Працюй із кореня репозиторію. Дотримуйся інструкцій [project-scaffold](../skills/project-scaffold/SKILL.md) щодо початкового `.gitignore` та ідемпотентності.

## Дії

1. Виконай `git rev-parse --is-inside-work-tree`. Якщо результат не `true`, виконай `git init`; не створюй новий репозиторій поверх наявного.
2. Перевір і прочитай `.gitignore`, якщо файл існує. Створи його, якщо відсутній, і забезпеч наявність рядків `node_modules/`, `dist/`, `coverage/`, `*.log` рівно по одному разу, зберігаючи всі інші правила.
3. Покажи `git status --short --branch` і поточну гілку через `git branch --show-current`. Якщо гілку ще не створено, прямо зазнач це.
4. Не виконуй `git add`, `git commit` або `git push`.

Повторне виконання не дублює правила `.gitignore` і не змінює історію чи наявний Git-репозиторій.

## Очікувані файли

- `.gitignore` з потрібними правилами без дублів.
- `.git/` створюється лише якщо поточний каталог ще не є Git-репозиторієм.

## Команди перевірки

```powershell
git rev-parse --is-inside-work-tree
git status --short --branch
git branch --show-current
$lines = Get-Content .gitignore; foreach ($entry in @('node_modules/', 'dist/', 'coverage/', '*.log')) { if (@($lines | Where-Object { $_ -ceq $entry }).Count -ne 1) { throw "Expected exactly one .gitignore entry: $entry" } }
```

## Повідомлення про помилку

Зупинись і повідом етап, команду та точний текст помилки. Не виконуй наступний prompt, не створюй коміт і не відправляй зміни.