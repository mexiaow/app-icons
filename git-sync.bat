@echo off
echo ========== ��ʼͬ�� Git �ֿ� ==========
cd /d "%~dp0"

:: ����Ƿ��� Git �ֿ�
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ���󣺵�ǰĿ¼���� Git �ֿ⣡
    pause
    exit /b 1
)

:: ��ȡԶ�����´��루�����ͻ��
echo.
echo [1/3] ��ȡԶ�����¸���...
git pull origin main
if errorlevel 1 (
    echo ������ȡʧ�ܣ�����������ͻ��
    pause
    exit /b 1
)

:: ������и��Ĳ��ύ
echo.
echo [2/3] �ύ���ظ���...
git add .
git commit -m "�Զ�ͬ��: %date% %time%"
if errorlevel 1 (
    echo ���棺û�и��Ŀ��ύ�����ύʧ�ܣ�
)

:: ���͵�Զ�ֿ̲�
echo.
echo [3/3] ���͵�Զ�ֿ̲�...
git push origin main
if errorlevel 1 (
    echo ��������ʧ�ܣ�����Ȩ�޻����磡
    pause
    exit /b 1
)

echo.
echo ========== ͬ����ɣ� ==========
pause