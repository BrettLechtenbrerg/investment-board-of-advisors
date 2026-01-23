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

REM Step 5: Create Desktop Shortcut with Custom Icon
echo Step 5 of 5: Creating Desktop Shortcut with Custom Icon
echo --------------------------------------------------------

REM Detect the REAL Desktop path (Windows 11 often uses OneDrive Desktop)
set "DESKTOP="
if exist "%USERPROFILE%\OneDrive\Desktop" (
    set "DESKTOP=%USERPROFILE%\OneDrive\Desktop"
    echo    Detected OneDrive Desktop folder
) else if exist "%USERPROFILE%\Desktop" (
    set "DESKTOP=%USERPROFILE%\Desktop"
    echo    Detected standard Desktop folder
) else (
    REM Use PowerShell to get the actual Desktop path from registry
    for /f "usebackq tokens=*" %%a in (`powershell -ExecutionPolicy Bypass -Command "[Environment]::GetFolderPath('Desktop')"`) do set "DESKTOP=%%a"
)

if "%DESKTOP%"=="" (
    echo ⚠️  Could not find Desktop folder. Using default...
    set "DESKTOP=%USERPROFILE%\Desktop"
)

echo    Desktop path: %DESKTOP%
echo.

set "SHORTCUT_NAME=%USER_NAME%s Investment Board"
set "LAUNCHER_BAT=%SCRIPT_DIR%launcher.bat"
set "ICON_PATH=%SCRIPT_DIR%icon.ico"

REM Create the launcher batch file in the install directory
(
echo @echo off
echo title %USER_NAME%s Investment Board
echo cd /d "%SCRIPT_DIR%"
echo python main.py
echo pause
) > "%LAUNCHER_BAT%"

echo    Created launcher script...

REM Convert PNG to ICO using PowerShell (if icon.png exists)
if exist "%SCRIPT_DIR%icon.png" (
    echo    Converting icon from PNG to ICO...
    powershell -ExecutionPolicy Bypass -Command ^
    "try { ^
        Add-Type -AssemblyName System.Drawing; ^
        $img = [System.Drawing.Image]::FromFile('%SCRIPT_DIR%icon.png'); ^
        $bmp = New-Object System.Drawing.Bitmap($img, 64, 64); ^
        $icon = [System.Drawing.Icon]::FromHandle($bmp.GetHicon()); ^
        $stream = [System.IO.File]::Create('%ICON_PATH%'); ^
        $icon.Save($stream); ^
        $stream.Close(); ^
        $bmp.Dispose(); ^
        $img.Dispose(); ^
        Write-Host '    Icon converted successfully' ^
    } catch { ^
        Write-Host '    Icon conversion skipped (non-critical)' ^
    }"
)

REM Create the desktop shortcut using PowerShell
echo    Creating desktop shortcut...
powershell -ExecutionPolicy Bypass -Command ^
"try { ^
    $WshShell = New-Object -ComObject WScript.Shell; ^
    $lnkPath = Join-Path '%DESKTOP%' '%SHORTCUT_NAME%.lnk'; ^
    $Shortcut = $WshShell.CreateShortcut($lnkPath); ^
    $Shortcut.TargetPath = '%LAUNCHER_BAT%'; ^
    $Shortcut.WorkingDirectory = '%SCRIPT_DIR%'; ^
    $Shortcut.Description = 'Investment Board of Advisors'; ^
    $iconPath = '%ICON_PATH%'; ^
    if (Test-Path $iconPath) { $Shortcut.IconLocation = $iconPath }; ^
    $Shortcut.Save(); ^
    Write-Host '    Shortcut saved to:' $lnkPath ^
} catch { ^
    Write-Host 'ERROR:' $_.Exception.Message ^
    exit 1 ^
}"

if %errorlevel% equ 0 (
    echo.
    echo ✅ Desktop shortcut created!
) else (
    echo.
    echo ⚠️  PowerShell shortcut failed. Creating simple launcher instead...
    (
    echo @echo off
    echo title %USER_NAME%s Investment Board
    echo cd /d "%SCRIPT_DIR%"
    echo python main.py
    echo pause
    ) > "%DESKTOP%\%SHORTCUT_NAME%.bat"
    echo ✅ Fallback shortcut created on Desktop!
)
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
echo    (Look for the gold shield icon!)
echo.
echo Or run from command prompt:
echo   cd "%SCRIPT_DIR%"
echo   python main.py
echo.
pause
