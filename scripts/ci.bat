@echo off
call npm ci
if errorlevel 1 exit /b 1
call npm run build
if errorlevel 1 exit /b 1
call npm test
if errorlevel 1 exit /b 1
if not exist dist\hello.js (
  echo Expected dist\hello.js after build 1>&2
  exit /b 1
)
node dist\hello.js
if errorlevel 1 exit /b 1
