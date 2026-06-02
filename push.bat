@echo off
cd /d "%~dp0"
echo ================================
echo   Javi's Board - Deploy
echo ================================
echo.

:: ── 1. Open local file for testing ───────────────────────────────────────
echo Opening local version for testing...
start "" index.html
echo.
choice /M "Does it look good? Push to GitHub"
if errorlevel 2 (
  echo Cancelled. Nothing was pushed.
  pause & exit /b 0
)
echo.

:: ── 2. Require commit message ─────────────────────────────────────────────
if exist commit-msg.txt (
  set /p MSG=<commit-msg.txt
  echo Commit: %MSG%
  del commit-msg.txt
) else (
  echo ERROR: No commit-msg.txt found.
  echo Claude must describe the changes before you push.
  pause & exit /b 1
)
echo.

:: ── 3. Commit and push ────────────────────────────────────────────────────
git add -A
git commit -m "%MSG%"
git push

echo.
echo Done! https://JaviLif.github.io/javi-board/
pause
