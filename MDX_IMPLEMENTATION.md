# MDX Design System Implementation

This app follows the **MDX (Migros Design Experience)** design system guidelines.

## References
- **Components Library**: https://mdx.migros.ch/latest/components/components/actions/button/design-4FZchdvB
- **Storybook**: https://mdx-storybook.migros.ch/?path=/docs/migros-design-experience-mdx-introduction--docs

## Implemented Components

### 1. MDXButton Component
Located in `MDXButton.swift`

**Button Types** (as per MDX guidelines):
- **Primary**: Main actions (orange background, white text)
- **Secondary**: Secondary actions (outlined, orange border)
- **Tertiary**: Supporting actions (text link style)
- **Quaternary**: Subtle interactions (light background)

**Sizes**:
- Small: 36pt height
- Medium: 44pt height (default, meets accessibility)
- Large: 52pt height

**Mobile Optimization**:
- Full-width buttons on mobile (per MDX guidelines)
- Stacked button groups on mobile
- Proper touch target sizes (minimum 44pt)

### 2. Design Tokens
Located in `MDXDesignTokens.swift`

**Colors**:
- Primary: Migros orange (#FF6600)
- Primary Light: Light peach background
- Text Primary/Secondary: Black/Gray
- Background: White

**Spacing**:
- xs: 4pt
- sm: 8pt
- md: 16pt
- lg: 24pt
- xl: 32pt
- xxl: 40pt

**Typography**:
- Heading 1: 28pt, bold
- Heading 2: 24pt, bold
- Heading 3: 20pt, semibold
- Body: 16pt, regular
- Button: 16pt, semibold

## MDX Best Practices Applied

### ✅ Button Labels
- **Sentence case**: "Add product" (not "Add Product")
- **Descriptive**: "Add product" (not "OK" or "Click here")
- **Short & concise**: Clear action-oriented language

### ✅ Mobile Patterns
- **Full-width buttons** on mobile screens
- **Stacked buttons** when multiple actions are present
- **Proper spacing** for touch targets
- **No crowding** - buttons don't sit side-by-side on mobile

### ✅ Visual Hierarchy
- **One primary button** per screen
- **Clear button types** for different action importance
- **Icons only when beneficial** (not decorative)

### ✅ Accessibility
- **Minimum button height**: 44pt (medium size)
- **Clear contrast** between text and background
- **Disabled states** with reduced opacity

## Usage Examples

### Primary Button (Full-width on mobile)
```swift
MDXButton.mobile(
    "Add product",
    icon: Image(systemName: "plus"),
    type: .primary,
    action: {
        // Action
    }
)
```

### Button Group (Stacked on mobile)
```swift
VStack(spacing: MDXSpacing.md) {
    MDXButton.mobile("Add to basket", type: .primary, action: {})
    MDXButton.mobile("Cancel", type: .secondary, action: {})
}
```

### Standard Button (Auto-width)
```swift
MDXButton(
    "Learn more",
    type: .tertiary,
    action: {}
)
```

## Mobile-Specific Guidelines

Based on MDX documentation:

1. **Full-width buttons** on mobile (use `.mobile()` helper)
2. **Stack buttons vertically** when multiple actions
3. **Minimum 44pt height** for touch targets
4. **Proper spacing** between interactive elements
5. **Avoid side-by-side buttons** on mobile

## Next Steps

To extend the MDX implementation:

1. Add more MDX components (Inputs, Navigation, etc.)
2. Implement MDX patterns (forms, cards, etc.)
3. Add MDX theming support
4. Create MDX-compliant icon system
5. Add loading states and animations

## Files Structure

```
Grocery Shopping/
├── MDXDesignTokens.swift    # Colors, spacing, typography
├── MDXButton.swift          # Button component
└── BasketView.swift         # Updated to use MDX components
```

