@echo off
cd /d "%~dp0"

echo Pushing Javi's Board to GitHub...
echo.

git add -A

if exist commit-msg.txt (
  set /p MSG=<commit-msg.txt
  git commit -m "%MSG%"
  del commit-msg.txt
) else (
  git commit -m "v0.4: fix METAR CORS error via corsproxy, add no-cache headers so phone always loads latest"
)

git push

echo.
echo Done! https://JaviLif.github.io/javi-board/
pause
