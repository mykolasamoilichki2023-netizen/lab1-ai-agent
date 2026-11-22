# Лабораторна робота №1

- **Тема:** «Проєктування AI-агента для автоматизації розробки та CI/CD»
- **Студент:** Самойліч Микола Володимирович
- **Група:** КІ-408, номер у списку: 18
- **Варіант 6:** TypeScript, складання через npm scripts, тестування Vitest
**AI-інструмент:** GitHub Copilot у VS Code (custom agent, prompt files та agent skills)

## Мета

Спроєктувати AI-агента, який автоматизує створення TypeScript-проєкту та перевірку його складання і тестів у CI/CD.

## Ідея проєкту

Агент `build-engineer` за командою `/lab-init` послідовно налаштовує Git, генерує кросплатформний застосунок Hello World на TypeScript із тестом `BasicAddition`, створює скрипти `ci.sh` і `ci.bat`, а також GitHub Actions workflow для Windows, Linux і macOS. Скрипти встановлюють залежності, збирають проєкт, запускають тести та створюють файл застосунку `dist/hello.js`. Його можна запустити через `npm run start` або `node dist/hello.js`.

## Як запустити агента

1. Відкрити репозиторій у VS Code.
2. У Copilot Chat вибрати агента `build-engineer`.
3. Виконати команду `/lab-init`.

## Структура репозиторію

```text
.
├── .gitignore
├── .github/
│   ├── agents/
│   │   └── build-engineer.agent.md
│   ├── prompts/
│   │   ├── check.prompt.md
│   │   ├── create-actions.prompt.md
│   │   ├── create-build.prompt.md
│   │   ├── create-project.prompt.md
│   │   ├── git-init.prompt.md
│   │   └── lab-init.prompt.md
│   ├── skills/
│   │   ├── build-and-test/SKILL.md
│   │   ├── github-actions/SKILL.md
│   │   └── project-scaffold/SKILL.md
│   └── workflows/
│       └── ci.yml
├── docs/
│   ├── ai-log.md
│   ├── architecture.md
│   └── usage.md
├── scripts/
│   ├── ci.bat
│   └── ci.sh
├── src/
│   └── index.ts
├── tests/
│   └── BasicAddition.test.ts
├── package.json
├── tsconfig.json
├── vitest.config.ts
└── README.md
```

## Гілки

- `master` — фінальна версія.
- `develop` — лише агент та інструкції.
- `feature/lab1-generated` — результат запуску агента.

## Запуск

Запустіть застосунок командою:

```text
npm run start
```
