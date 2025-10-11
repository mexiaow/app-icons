chcp 65001

@echo off
echo ========== 开始同步 Git 仓库 ==========

cd /d "%~dp0"
set PATH=%PATH%;C:\Program Files\Git\bin

:: 拉取远程最新代码（避免冲突），使用正确的远程仓库
echo.
echo [1/3] 拉取远程最新更改...
git pull github main
if errorlevel 1 (
    echo 错误：拉取失败，请检查网络或冲突！
    pause
    exit /b 1
)

:: 添加所有更改并提交
echo.
echo [2/3] 提交本地更改...
git add .
git commit -m "Auto-sync: %date% %time%"
if errorlevel 1 (
    echo 警告：没有更改可提交，或提交失败！
)

:: 推送到 GitHub
echo.
echo [3/3] 推送到 GitHub...
git push github main
if errorlevel 1 (
    echo 错误：推送到 GitHub 失败，请检查权限或网络！
    pause
    exit /b 1
)

:: 推送到 Gitee
echo.
echo [4/3] 推送到 Gitee...
git push gitee main
if errorlevel 1 (
    echo 错误：推送到 Gitee 失败，请检查权限或网络！
    pause
    exit /b 1
)

echo.
echo ========== 同步完成！ ==========
echo 等待 3 秒后退出...
timeout /t 3 /nobreak >nul

exit
