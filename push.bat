@echo off
cd /d "%~dp0"

echo ================================
echo   Javi's Board ^| Auto Deploy
echo ================================
echo.

:: ── 1. Check commit message written by Claude ─────────────────────────────
if not exist commit-msg.txt (
  echo ERROR: No commit-msg.txt file found.
  echo Claude must write this file before you push.
  pause & exit /b 1
)
set /p DESC=<commit-msg.txt
echo Changes : %DESC%

:: ── 2. Read current version from index.html, auto-bump minor ──────────────
powershell -NoProfile -Command ^
  "$c = Get-Content 'index.html' -Raw;" ^
  "$m = [regex]::Match($c, 'versionBadge[^>]*>v(\d+)\.(\d+)<');" ^
  "$major = $m.Groups[1].Value;" ^
  "$minor = [int]$m.Groups[2].Value + 1;" ^
  "Write-Output \"$major.$minor\"" ^
  > .ver.tmp
set /p NEWVER=<.ver.tmp
del .ver.tmp 2>nul
echo Version : v%NEWVER%

:: ── 3. Update version badge in index.html ─────────────────────────────────
powershell -NoProfile -Command ^
  "$c = Get-Content 'index.html' -Raw;" ^
  "$c = $c -replace '(versionBadge[^>]*>)v\d+\.\d+<', \"`${1}v%NEWVER%<\";" ^
  "[System.IO.File]::WriteAllText((Resolve-Path 'index.html'), $c)"

:: ── 4. Stage, commit, push ────────────────────────────────────────────────
git add -A
git commit -m "v%NEWVER%: %DESC%"
git push

:: ── 5. Clear commit message after successful push ─────────────────────────
del commit-msg.txt 2>nul

echo.
echo Done! v%NEWVER% live at https://JaviLif.github.io/javi-board/
echo.
t