---
agent: build-engineer
description: "Створює GitHub Actions CI workflow для Windows, Linux і macOS, який запускає локальні CI-скрипти."
---

# Створення GitHub Actions

## Передумови

Працюй із кореня репозиторію після успішного `/create-build`. Перевір наявність `scripts/ci.sh` і `scripts/ci.bat`; дотримуйся [github-actions](../skills/github-actions/SKILL.md).

## Дії

1. Виклич skill `github-actions` і ідемпотентно створи або онови `.github/workflows/ci.yml`, попередньо прочитавши наявний файл.
2. Workflow має запускатися для `push` і `pull_request` до `develop` та `master`, і для `workflow_dispatch`; job має перевіряти Ubuntu, Windows і macOS.
3. Після checkout і setup-node запускай лише `scripts\ci.bat` на Windows або `bash scripts/ci.sh` на інших ОС. Не додавай npm-команди безпосередньо до workflow.
4. Не дублюй наявні jobs чи кроки й не змінюй інші workflow.

## Очікувані файли

- `.github/workflows/ci.yml`.

## Команди перевірки

```powershell
Test-Path .github/workflows/ci.yml -PathType Leaf
npx --yes js-yaml .github/workflows/ci.yml
Select-String -Path .github/workflows/ci.yml -Pattern 'ubuntu-latest', 'windows-latest', 'macos-latest'
Select-String -Path .github/workflows/ci.yml -Pattern '\bnpm\s+(ci|install|run|test|build)\b'
```

YAML має розбиратися; перевір наявність усіх трьох ОС та відсутність збігів npm-команд. Дотримуйся повного переліку з [github-actions](../skills/github-actions/SKILL.md).

## Повідомлення про помилку

При першій помилці зупинись і повідом етап, команду та точний текст помилки. Не обходь помилку додаванням npm-команд у workflow; вкажи інструкції, які потребують виправлення.