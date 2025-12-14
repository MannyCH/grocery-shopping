# Grocery Shopping App - SwiftUI

A SwiftUI recreation of the grocery shopping app basket screen with interactive elements.

## Why SwiftUI for Prompt-Based Iteration?

**SwiftUI is ideal for rapid iteration because:**
- ⚡ **Xcode Previews** - See changes instantly as you type (no build needed)
- 🎯 **Native iOS** - Perfect look and feel out of the box
- 🔄 **Live Editing** - Modify code and see results in real-time
- 📱 **Device Preview** - Test on any iOS device/simulator instantly

## Setup Instructions

### Option 1: Create New Xcode Project (Recommended)

1. Open Xcode
2. Create a new project: **File → New → Project**
3. Choose **iOS → App**
4. Set:
   - Product Name: `GroceryShopping`
   - Interface: **SwiftUI**
   - Language: **Swift**
5. Copy all `.swift` files from this directory into your Xcode project
6. Replace the default `ContentView.swift` with these files

### Option 2: Use Existing Project

1. Add all `.swift` files to your Xcode project
2. Set `GroceryShoppingApp.swift` as the entry point
3. Build and run!

## Using Xcode Previews

1. Open any `.swift` file (e.g., `BasketView.swift`)
2. Click the **"Resume"** button in the preview canvas (or press `⌘ + Option + P`)
3. Make changes to the code - preview updates automatically!
4. Use the device selector to preview on different iPhone models

## Current Features

✅ Empty basket state matching the screenshot
✅ Custom header with delivery/store toggle
✅ Bottom tab navigation
✅ "Add product" button with sheet presentation
✅ Period selector ("Weekly" dropdown)
✅ Stylized illustration with people and shopping list
✅ iOS-native styling and interactions

## Adding Interactions

You can easily add interactions by modifying the views. For example:

- **Animations**: Add `.animation()` modifiers
- **Gestures**: Use `.gesture()` modifiers
- **State changes**: Update `@State` variables
- **Navigation**: Use `NavigationLink` or sheet presentations

## Example: Adding Animation

```swift
@State private var isAnimating = false

Button(action: {
    withAnimation(.spring()) {
        isAnimating.toggle()
    }
}) {
    Text("Add product")
}
.scaleEffect(isAnimating ? 1.1 : 1.0)
```

The preview will update immediately showing the animation!

## Project Structure

```
GroceryShoppingApp.swift    # App entry point
MainTabView.swift           # Tab navigation container
BasketView.swift            # Main basket screen with empty state
```

## Next Steps

- Add product list when basket has items
- Implement "Add product" functionality
- Add shopping list view
- Implement period selector dropdown
- Add more animations and transitions

