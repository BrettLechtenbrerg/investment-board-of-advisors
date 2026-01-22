@echo off
REM ============================================================
REM   Investment Board of Advisors - Windows Setup Script
REM   Get wisdom from 9 legendary investors!
REM ============================================================

title Investment Board of Advisors - Setup

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║      💰  INVESTMENT BOARD OF ADVISORS - SETUP  💰            ║
echo ║                                                              ║
echo ║   Get wisdom from 9 legendary investors                      ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

REM Step 1: Get user's name
echo Step 1 of 5: Personalization
echo ----------------------------
set /p USER_NAME="What's your first name? > "

if "%USER_NAME%"=="" set USER_NAME=Investor

echo.
echo Nice to meet you, %USER_NAME%! 📈
echo.

REM Step 2: Check for Python
echo Step 2 of 5: Checking Python Installation
echo ------------------------------------------
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python is not installed or not in PATH!
    echo.
    echo Please install Python 3 from: https://python.org/downloads
    echo IMPORTANT: Check "Add Python to PATH" during installation!
    echo.
    pause
    exit /b 1
)
echo ✅ Python found!
echo.

REM Step 3: Get API Key
echo Step 3 of 5: API Key Configuration
echo -----------------------------------
echo You'll need an Anthropic API key to use the Investment Board.
echo.
echo 📌 Don't have one? Get it free at: https://console.anthropic.com
echo    (You'll get some free credits to start!)
echo.
set /p API_KEY="Paste your Anthropic API key (starts with sk-ant-): "

if "%API_KEY%"=="" (
    echo.
    echo ❌ No API key entered. Please run setup again when you have one.
    pause
    exit /b 1
)

REM Create .env file
echo.
echo Creating configuration file...
(
echo # Investment Board of Advisors Configuration
echo # Created for: %USER_NAME%
echo # Date: %date% %time%
echo.
echo ANTHROPIC_API_KEY=%API_KEY%
) > "%SCRIPT_DIR%.env"

echo ✅ Configuration saved!
echo.

REM Step 4: Install dependencies
echo Step 4 of 5: Installing Dependencies
echo -------------------------------------
echo Installing required Python packages...
pip install anthropic python-dotenv >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Warning: There may have been an issue installing packages.
    echo    Try running: pip install anthropic python-dotenv
) else (
    echo ✅ Dependencies installed!
)
echo.

REM Step 5: Create Desktop Shortcut
echo Step 5 of 5: Creating Desktop Shortcut
echo ---------------------------------------

set "DESKTOP=%USERPROFILE%\Desktop"
set "SHORTCUT_NAME=%USER_NAME%'s Investment Board"
set "BAT_FILE=%DESKTOP%\%SHORTCUT_NAME%.bat"

REM Create the launcher batch file
(
echo @echo off
echo title %USER_NAME%'s Investment Board
echo cd /d "%SCRIPT_DIR%"
echo echo.
echo echo 💰  %USER_NAME%'s INVESTMENT BOARD  💰
echo echo.
echo python main.py
echo pause
) > "%BAT_FILE%"

echo ✅ Desktop shortcut created!
echo.

REM Setup complete
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    ✅ SETUP COMPLETE!                        ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 🎉 Welcome to your Investment Board, %USER_NAME%!
echo.
echo Your 9 advisors are ready:
echo   📈 Warren Buffett  - Value Investing ^& Business Analysis
echo   🧪 Peter Lynch     - Growth Investing ^& Research
echo   🌊 Ray Dalio       - Macro Economics ^& Principles
echo   📊 John Bogle      - Index Investing ^& Low-Cost Strategy
echo   📚 Benjamin Graham - Father of Value Investing
echo   🌍 George Soros    - Macro Trading ^& Reflexivity
echo   📝 Howard Marks    - Risk Assessment ^& Market Cycles
echo   ⚔️  Carl Icahn      - Activist Investing
echo   🚀 Cathie Wood     - Disruptive Innovation ^& Growth
echo.
echo ⚠️  DISCLAIMER: This is for educational purposes only.
echo    This is NOT financial advice. Always consult professionals.
echo.
echo 📍 To launch: Double-click "%SHORTCUT_NAME%" on your Desktop
echo.
echo Or run from command prompt:
echo   cd "%SCRIPT_DIR%"
echo   python main.py
echo.
pause
