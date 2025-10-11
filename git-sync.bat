chcp 65001

@echo off
setlocal enabledelayedexpansion

echo ========== 开始同步 Git 仓库 ==========

cd /d "%~dp0"
set PATH=%PATH%;C:\Program Files\Git\bin

:: 链接前缀（用于拼接剪贴板链接）
set "BASE_URL=https://logo.xwat.cn/"

:: 清理上次可能遗留的临时文件
del /f /q "__new_files.txt" "__urls.txt" 2>nul

:: 拉取远程最新代码（避免冲突），使用正确的远程仓库
echo.
echo [1/5] 拉取远程最新更改...
git pull github main
if errorlevel 1 (
    echo 错误：拉取失败，请检查网络或冲突！
    pause
    exit /b 1
)

:: 添加所有更改，并采集本次提交中"新增"到 app 目录的文件清单
echo.
echo [2/5] 暂存更改并收集新增文件...
git add .
:: 收集本次提交中新增（A）的 app/ 下文件，供后续生成链接
git diff --cached --name-only --diff-filter=A -- app > "__new_files.txt"

:: 提交本地更改
echo.
echo [3/5] 提交本地更改...
git commit -m "Auto-sync: %date% %time%"
if errorlevel 1 (
    echo 警告：没有更改可提交，或提交失败！
)

:: 推送到 GitHub
echo.
echo [4/5] 推送到 GitHub...
git push github main
if errorlevel 1 (
    echo 错误：推送到 GitHub 失败，请检查权限或网络！
    pause
    exit /b 1
)

:: 推送到 Gitee
echo.
echo [5/5] 推送到 Gitee...
git push gitee main
if errorlevel 1 (
    echo 错误：推送到 Gitee 失败，请检查权限或网络！
    pause
    exit /b 1
)

:: 根据新增清单生成链接并复制到剪贴板（多文件多行）
set "NEW_COUNT=0"
if exist "__new_files.txt" (
    for /f %%A in ('^<"__new_files.txt" find /v /c ""') do set NEW_COUNT=%%A
)

if %NEW_COUNT% GEQ 1 (
    echo.
    echo [链接] 本次新增 app 文件：%NEW_COUNT% 个，生成链接...
    (
        for /f "usebackq delims=" %%F in ("__new_files.txt") do @echo %BASE_URL%%%F
    ) > "__urls.txt"

    echo.
    echo [链接] 以下链接已生成：
    type "__urls.txt"

    echo.
    echo [剪贴板] 正在复制链接到剪贴板...
    type "__urls.txt" | clip
    if errorlevel 1 (
        powershell -NoProfile -Command "Get-Content -Raw \"__urls.txt\" ^| Set-Clipboard"
    )
    echo [剪贴板] 完成，可直接粘贴使用。
) else (
    echo.
    echo [链接] 未发现新增的 app 文件，本次不生成链接。
)

:: 清理临时文件
del /f /q "__new_files.txt" "__urls.txt" 2>nul

echo.
echo ========== 同步完成！ ==========
echo 等待 3 秒后退出...
timeout /t 3 /nobreak >nul

endlocal
exit
