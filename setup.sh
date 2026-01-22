#!/bin/bash
#
# 💰 Investment Board of Advisors - Setup Script
#
# This script will set up your personal Investment Board of Advisors
# You'll need an Anthropic API key (get one at https://console.anthropic.com)
#

clear
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║      💰  INVESTMENT BOARD OF ADVISORS - SETUP  💰           ║"
echo "║                                                              ║"
echo "║   Get wisdom from 9 legendary investors                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Step 1: Get user's name
echo "Step 1 of 4: Personalization"
echo "----------------------------"
read -p "What's your first name? > " USER_NAME

if [ -z "$USER_NAME" ]; then
    USER_NAME="Investor"
fi

echo ""
echo "Nice to meet you, $USER_NAME! 📈"
echo ""

# Step 2: Get API Key
echo "Step 2 of 4: API Key Configuration"
echo "-----------------------------------"
echo "You'll need an Anthropic API key to use the Investment Board."
echo ""
echo "📌 Don't have one? Get it free at: https://console.anthropic.com"
echo "   (You'll get some free credits to start!)"
echo ""
read -p "Paste your Anthropic API key (starts with sk-ant-): " API_KEY

if [ -z "$API_KEY" ]; then
    echo ""
    echo "❌ No API key entered. Please run setup again when you have one."
    exit 1
fi

# Validate it looks like an API key
if [[ ! "$API_KEY" == sk-ant-* ]]; then
    echo ""
    echo "⚠️  Warning: That doesn't look like an Anthropic API key."
    echo "   Anthropic keys usually start with 'sk-ant-'"
    read -p "Continue anyway? (y/n): " CONTINUE
    if [ "$CONTINUE" != "y" ]; then
        exit 1
    fi
fi

# Create .env file
echo ""
echo "Creating configuration file..."
cat > "$SCRIPT_DIR/.env" << EOF
# Investment Board of Advisors Configuration
# Created for: $USER_NAME
# Date: $(date)

ANTHROPIC_API_KEY=$API_KEY
EOF

echo "✅ Configuration saved!"
echo ""

# Step 3: Install dependencies
echo "Step 3 of 4: Installing Dependencies"
echo "-------------------------------------"
echo "Installing required Python packages..."

# Check if pip3 exists
if command -v pip3 &> /dev/null; then
    pip3 install -q anthropic python-dotenv 2>/dev/null
    echo "✅ Dependencies installed!"
else
    echo "⚠️  pip3 not found. Please install Python 3 first."
    echo "   Download from: https://www.python.org/downloads/"
    exit 1
fi

echo ""

# Step 4: Create Desktop App
echo "Step 4 of 4: Creating Desktop App"
echo "----------------------------------"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - create .app bundle
    APP_NAME="${USER_NAME}'s Investment Board"
    APP_PATH="$HOME/Desktop/$APP_NAME.app"

    echo "Creating macOS app: $APP_NAME"

    mkdir -p "$APP_PATH/Contents/MacOS"
    mkdir -p "$APP_PATH/Contents/Resources"

    # Create launcher script
    cat > "$APP_PATH/Contents/MacOS/launcher" << EOF
#!/bin/bash
osascript -e 'tell application "Terminal"
    activate
    do script "cd \"$SCRIPT_DIR\" && clear && echo \"\" && echo \"💰  ${USER_NAME}'"'"'s INVESTMENT BOARD  💰\" && echo \"\" && python3 main.py"
end tell'
EOF
    chmod +x "$APP_PATH/Contents/MacOS/launcher"

    # Create Info.plist
    cat > "$APP_PATH/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>launcher</string>
    <key>CFBundleIdentifier</key>
    <string>com.investmentboard.${USER_NAME,,}</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

    # Copy icon if it exists
    if [ -f "$SCRIPT_DIR/icon.png" ]; then
        echo "Found custom icon, applying..."
        mkdir -p /tmp/AppIcon.iconset
        sips -z 16 16 "$SCRIPT_DIR/icon.png" --out /tmp/AppIcon.iconset/icon_16x16.png 2>/dev/null
        sips -z 32 32 "$SCRIPT_DIR/icon.png" --out /tmp/AppIcon.iconset/icon_16x16@2x.png 2>/dev/null
        sips -z 32 32 "$SCRIPT_DIR/icon.png" --out /tmp/AppIcon.iconset/icon_32x32.png 2>/dev/null
        sips -z 64 64 "$SCRIPT_DIR/icon.png" --out /tmp/AppIcon.iconset/icon_32x32@2x.png 2>/dev/null
        sips -z 128 128 "$SCRIPT_DIR/icon.png" --out /tmp/AppIcon.iconset/icon_128x128.png 2>/dev/null
        sips -z 256 256 "$SCRIPT_DIR/icon.png" --out /tmp/AppIcon.iconset/icon_128x128@2x.png 2>/dev/null
        sips -z 256 256 "$SCRIPT_DIR/icon.png" --out /tmp/AppIcon.iconset/icon_256x256.png 2>/dev/null
        sips -z 512 512 "$SCRIPT_DIR/icon.png" --out /tmp/AppIcon.iconset/icon_256x256@2x.png 2>/dev/null
        sips -z 512 512 "$SCRIPT_DIR/icon.png" --out /tmp/AppIcon.iconset/icon_512x512.png 2>/dev/null
        sips -z 1024 1024 "$SCRIPT_DIR/icon.png" --out /tmp/AppIcon.iconset/icon_512x512@2x.png 2>/dev/null
        iconutil -c icns /tmp/AppIcon.iconset -o "$APP_PATH/Contents/Resources/AppIcon.icns" 2>/dev/null

        # Add icon reference to Info.plist
        sed -i '' 's|</dict>|    <key>CFBundleIconFile</key>\n    <string>AppIcon</string>\n</dict>|' "$APP_PATH/Contents/Info.plist"
        rm -rf /tmp/AppIcon.iconset
    fi

    echo "✅ Desktop app created!"

else
    # Linux/Windows - create shell script shortcut
    echo "Creating launcher script on Desktop..."
    cat > "$HOME/Desktop/${USER_NAME}_Investment_Board.sh" << EOF
#!/bin/bash
cd "$SCRIPT_DIR"
python3 main.py
EOF
    chmod +x "$HOME/Desktop/${USER_NAME}_Investment_Board.sh"
    echo "✅ Desktop launcher created!"
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    ✅ SETUP COMPLETE!                        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "🎉 Welcome to your Investment Board, $USER_NAME!"
echo ""
echo "Your 9 advisors are ready:"
echo "  📈 Warren Buffett  - Value Investing & Business Analysis"
echo "  🧪 Peter Lynch     - Growth Investing & Research"
echo "  🌊 Ray Dalio       - Macro Economics & Principles"
echo "  📊 John Bogle      - Index Investing & Low-Cost Strategy"
echo "  📚 Benjamin Graham - Father of Value Investing"
echo "  🌍 George Soros    - Macro Trading & Reflexivity"
echo "  📝 Howard Marks    - Risk Assessment & Market Cycles"
echo "  ⚔️  Carl Icahn      - Activist Investing"
echo "  🚀 Cathie Wood     - Disruptive Innovation & Growth"
echo ""
echo "⚠️  DISCLAIMER: This is for educational purposes only."
echo "   This is NOT financial advice. Always consult professionals."
echo ""
echo "📍 To launch: Double-click '$APP_NAME' on your Desktop"
echo ""
echo "Or run from terminal:"
echo "  cd \"$SCRIPT_DIR\""
echo "  python3 main.py"
echo ""
read -p "Press Enter to exit setup..."
