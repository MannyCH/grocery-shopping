import SwiftUI

// MARK: - MDX Button Component
// Based on MDX Design System: https://mdx.migros.ch/latest/components/components/actions/button/design-4FZchdvB

enum MDXButtonType {
    case primary
    case secondary
    case tertiary
    case quaternary
}

enum MDXButtonSize {
    case small
    case medium
    case large
    
    var height: CGFloat {
        switch self {
        case .small: return 36
        case .medium: return 44 // Default, meets accessibility requirements
        case .large: return 52
        }
    }
    
    var fontSize: Font {
        switch self {
        case .small: return MDXTypography.buttonSmall
        case .medium: return MDXTypography.button
        case .large: return MDXTypography.button
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return MDXSpacing.md
        case .medium: return MDXSpacing.lg
        case .large: return MDXSpacing.xl
        }
    }
}

struct MDXButton: View {
    let label: String
    let icon: Image?
    let iconPosition: IconPosition
    let type: MDXButtonType
    let size: MDXButtonSize
    let isFullWidth: Bool
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    enum IconPosition {
        case leading
        case trailing
    }
    
    init(
        _ label: String,
        icon: Image? = nil,
        iconPosition: IconPosition = .leading,
        type: MDXButtonType = .primary,
        size: MDXButtonSize = .medium,
        isFullWidth: Bool = false,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.iconPosition = iconPosition
        self.type = type
        self.size = size
        self.isFullWidth = isFullWidth
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            if !isDisabled && !isLoading {
                action()
            }
        }) {
            HStack(spacing: MDXSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.8)
                } else {
                    if let icon = icon, iconPosition == .leading {
                        icon
                            .font(size.iconSize)
                    }
                    
                    Text(label)
                        .font(size.fontSize)
                        .lineLimit(1)
                    
                    if let icon = icon, iconPosition == .trailing {
                        icon
                            .font(size.iconSize)
                    }
                }
            }
            .foregroundColor(foregroundColor)
            .frame(height: size.height)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, size.horizontalPadding)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: MDXCornerRadius.medium)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .cornerRadius(MDXCornerRadius.medium)
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    private var foregroundColor: Color {
        switch type {
        case .primary:
            return .white
        case .secondary:
            return MDXColors.primary
        case .tertiary:
            return MDXColors.textPrimary
        case .quaternary:
            return MDXColors.textSecondary
        }
    }
    
    private var backgroundColor: Color {
        switch type {
        case .primary:
            return MDXColors.primary
        case .secondary:
            return .clear
        case .tertiary:
            return .clear
        case .quaternary:
            return MDXColors.surface
        }
    }
    
    private var borderColor: Color {
        switch type {
        case .primary:
            return .clear
        case .secondary:
            return MDXColors.primary
        case .tertiary:
            return .clear
        case .quaternary:
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch type {
        case .primary, .tertiary, .quaternary:
            return 0
        case .secondary:
            return 1.5
        }
    }
}

extension MDXButtonSize {
    var iconSize: Font {
        switch self {
        case .small: return .system(size: 14)
        case .medium: return .system(size: 16)
        case .large: return .system(size: 18)
        }
    }
}

// MARK: - Mobile-Specific Button Extension
// MDX Guidelines: Full-width buttons on mobile, stack multiple buttons
extension MDXButton {
    /// Creates a mobile-optimized button (full-width on mobile)
    static func mobile(
        _ label: String,
        icon: Image? = nil,
        type: MDXButtonType = .primary,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) -> MDXButton {
        MDXButton(
            label,
            icon: icon,
            type: type,
            size: .medium,
            isFullWidth: true, // MDX: Full-width on mobile
            isLoading: isLoading,
            isDisabled: isDisabled,
            action: action
        )
    }
}

// MARK: - Preview
struct MDXButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: MDXSpacing.md) {
            MDXButton("Add product", icon: Image(systemName: "plus"), type: .primary, action: {})
            MDXButton("Cancel", type: .secondary, action: {})
            MDXButton("Learn more", type: .tertiary, action: {})
            MDXButton("Skip", type: .quaternary, action: {})
            
            MDXButton.mobile("Add product", icon: Image(systemName: "plus"), action: {})
        }
        .padding()
        .previewDevice("iPhone 14 Pro")
    }
}

