@echo off
REM ============================================================
REM   Python Installation Checker
REM   Run this FIRST to make sure Python is ready!
REM ============================================================

title Python Installation Checker

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║           PYTHON INSTALLATION CHECKER                        ║
echo ║                                                              ║
echo ║   Run this to verify Python is installed correctly          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo Checking for Python...
echo.

python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ╔══════════════════════════════════════════════════════════════╗
    echo ║                    ❌ PYTHON NOT FOUND                       ║
    echo ╚══════════════════════════════════════════════════════════════╝
    echo.
    echo Python is NOT installed or NOT in your PATH.
    echo.
    echo ══════════════════════════════════════════════════════════════
    echo WHAT TO DO:
    echo ══════════════════════════════════════════════════════════════
    echo.
    echo 1. Download Python from: https://www.python.org/downloads/
    echo.
    echo 2. Run the installer
    echo.
    echo 3. ⚠️  IMPORTANT: Check the box that says:
    echo    "Add python.exe to PATH"
    echo.
    echo 4. Click "Install Now"
    echo.
    echo 5. RESTART YOUR COMPUTER
    echo.
    echo 6. Run this checker again to verify
    echo.
    echo ══════════════════════════════════════════════════════════════
    echo.
    echo Opening Python download page for you...
    timeout /t 3 >nul
    start https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    ✅ PYTHON FOUND!                          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
python --version
echo.
echo ══════════════════════════════════════════════════════════════
echo GREAT NEWS: Python is installed and ready!
echo ══════════════════════════════════════════════════════════════
echo.
echo You can now run setup.bat to install the Investment Board.
echo.
echo Next step: Double-click "setup.bat"
echo.
pause
