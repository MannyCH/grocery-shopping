# Exact Xcode Project Setup Instructions

## Step-by-Step Guide

### Step 1: Open Xcode
- Launch Xcode from Applications or Spotlight

### Step 2: Create New Project
- **File → New → Project** (or press `⌘ + Shift + N`)

### Step 3: Select Template
- Choose **iOS** tab at the top
- Select **App** template
- Click **Next**

### Step 4: Configure Project Options

Fill in these **exact** values:

**Product Name:** `GroceryShopping`

**Team:** (Select your Apple Developer account, or "None" if you don't have one)

**Organization Identifier:** `com.yourname` (or your domain, e.g., `com.example`)

**Bundle Identifier:** (Auto-filled as `com.yourname.GroceryShopping` - leave as is)

**Interface:** Select **SwiftUI** ⚠️ (This is critical!)

**Language:** Select **Swift** ⚠️ (This is critical!)

**Storage:** Leave as **None** (or choose if you need Core Data)

**Include Tests:** ✅ Check this box (optional but recommended)

**Click Next**

### Step 5: Choose Location
- Navigate to: `/Users/manuelrohrbach/repo/grocery-shopping/`
- **IMPORTANT:** Uncheck "Create Git repository" if you want to use your existing repo
- Click **Create**

### Step 6: Replace Default Files

After Xcode creates the project, you'll see:
- `GroceryShoppingApp.swift` (default entry point)
- `ContentView.swift` (default view)

**Do this:**

1. **Delete the default `ContentView.swift`:**
   - Right-click `ContentView.swift` in the Project Navigator
   - Select "Delete"
   - Choose "Move to Trash"

2. **Add the project files:**
   - Right-click on the project folder in Project Navigator
   - Select "Add Files to GroceryShopping..."
   - Navigate to the repo directory
   - Select all `.swift` files:
     - `GroceryShoppingApp.swift`
     - `MainTabView.swift`
     - `BasketView.swift`
   - Make sure "Copy items if needed" is **unchecked** (since files are already in the right place)
   - Make sure "Create groups" is selected
   - Click **Add**

3. **Verify the entry point:**
   - Open `GroceryShoppingApp.swift`
   - It should have `@main` attribute and `GroceryShoppingApp` struct
   - If Xcode created a different one, replace it with our version

### Step 7: Open Preview

1. Open `BasketView.swift` in the editor
2. Look for the preview canvas on the right side
3. If you don't see it:
   - Go to **Editor → Canvas** (or press `⌘ + Option + Return`)
4. Click the **"Resume"** button in the preview pane
5. You should see the basket screen!

### Step 8: Run on Simulator

1. Select a simulator from the device menu (top toolbar):
   - Click the device selector (shows "iPhone 15" or similar)
   - Choose any iPhone (e.g., "iPhone 15 Pro")
2. Click the **Play** button (▶️) or press `⌘ + R`
3. The app will build and launch in the simulator

## Troubleshooting

### If preview doesn't work:
- Make sure you selected **SwiftUI** as the interface
- Try: **Product → Clean Build Folder** (`⌘ + Shift + K`)
- Then: **Product → Build** (`⌘ + B`)

### If files show errors:
- Make sure all files are added to the target:
  - Select a file in Project Navigator
  - Open File Inspector (right panel)
  - Under "Target Membership", check "GroceryShopping"

### If build fails:
- Check that `GroceryShoppingApp.swift` has `@main` attribute
- Only one file should have `@main` - delete any duplicate entry points

## Quick Reference: Key Settings

| Setting | Value |
|---------|-------|
| **Interface** | SwiftUI |
| **Language** | Swift |
| **Platform** | iOS |
| **Minimum Deployment** | iOS 15.0+ (or latest) |

## What You Should See

After setup:
- ✅ Project opens in Xcode
- ✅ Preview shows the basket screen
- ✅ App runs in simulator
- ✅ Tab navigation works
- ✅ "Add product" button opens a sheet

