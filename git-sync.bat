@echo off
echo ========== 开始同步 Git 仓库 ==========
cd /d "%~dp0"

:: 检查是否在 Git 仓库
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo 错误：当前目录不是 Git 仓库！
    pause
    exit /b 1
)

:: 拉取远程最新代码（避免冲突）
echo.
echo [1/3] 拉取远程最新更改...
git pull origin main
if errorlevel 1 (
    echo 错误：拉取失败，请检查网络或冲突！
    pause
    exit /b 1
)

:: 添加所有更改并提交
echo.
echo [2/3] 提交本地更改...
git add .
git commit -m "Auto-sync: $(date +"%Y-%m-%d %H:%M:%S")"
if errorlevel 1 (
    echo 警告：没有更改可提交，或提交失败！
)

:: 推送到远程仓库
echo.
echo [3/3] 推送到远程仓库...
git push origin main
if errorlevel 1 (
    echo 错误：推送失败，请检查权限或网络！
    pause
    exit /b 1
)

echo.
echo ========== 同步完成！ ==========
pause