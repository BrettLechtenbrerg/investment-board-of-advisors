# 💰 Windows Quick Start Guide

## This guide has just 2 parts:
1. **Install Python** (one time only - 5 minutes)
2. **Run Setup** (2 minutes)

---

# PART 1: Install Python (Skip if you already have Python)

## Step 1: Download Python
1. Click this link: **[Download Python](https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe)**
2. A file will download. Find it in your Downloads folder.

## Step 2: Run the Installer
1. **Double-click** the downloaded file (`python-3.12.0-amd64.exe`)
2. You'll see a window like this:

```
┌─────────────────────────────────────────────────────────────┐
│                     Install Python 3.12                      │
│                                                              │
│  ☐ Install launcher for all users (recommended)             │
│  ☑ Add python.exe to PATH  ← ← ← CHECK THIS BOX! ← ← ←     │
│                                                              │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │  Install Now    │    │   Customize     │                │
│  └─────────────────┘    └─────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

3. **⚠️ IMPORTANT:** Check the box that says **"Add python.exe to PATH"**
4. Click **"Install Now"**
5. Wait for installation to complete
6. Click **"Close"**

## Step 3: Restart Your Computer
1. Click Start → Power → **Restart**
2. Wait for computer to restart
3. Come back to this guide!

## Step 4: Verify Python is Working
1. Press **Windows key + R** on your keyboard
2. Type `cmd` and press Enter
3. In the black window that opens, type: `python --version`
4. Press Enter

**✅ If you see:** `Python 3.12.0` (or similar) → **SUCCESS! Go to Part 2!**

**❌ If you see:** `'python' is not recognized...` → Go back to Step 2 and make sure you checked "Add to PATH"

---

# PART 2: Run the Investment Board Setup

## Step 1: Download the Investment Board
1. Go to: **[github.com/BrettLechtenbrerg/investment-board-of-advisors](https://github.com/BrettLechtenbrerg/investment-board-of-advisors)**
2. Click the green **"Code"** button
3. Click **"Download ZIP"**
4. Find the ZIP in your Downloads folder
5. **Right-click** the ZIP → **"Extract All"** → **"Extract"**

## Step 2: Run Setup
1. Open the extracted folder (`investment-board-of-advisors-main`)
2. Find the file called **`setup.bat`**
3. **Double-click** `setup.bat`

**⚠️ If Windows shows a warning:**
- Click **"More info"**
- Click **"Run anyway"**

## Step 3: Follow the Prompts
The setup will ask you:

```
What's your first name? > _
```
→ Type your name and press Enter

```
Paste your Anthropic API key (starts with sk-ant-): _
```
→ Paste your API key and press Enter

(Don't have an API key? Get one free at [console.anthropic.com](https://console.anthropic.com))

## Step 4: Done!
Look on your Desktop for: **"[YourName]'s Investment Board"**

Double-click it to start getting advice from legendary investors!

---

# ❓ Troubleshooting

### "Python is not recognized"
- Go back to Part 1 and reinstall Python
- Make sure to check **"Add python.exe to PATH"**
- Restart your computer after installing

### "Windows protected your PC" warning
- Click **"More info"**
- Click **"Run anyway"**

### Setup closes immediately
- Right-click `setup.bat`
- Click "Run as administrator"

### Still stuck?
- Make sure you restarted your computer after installing Python
- Try opening Command Prompt and typing `python --version` to verify Python works

---

# 🎥 Want a Video Tutorial?

Ask Brett for a screen recording walkthrough!
