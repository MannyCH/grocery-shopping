import SwiftUI

// MARK: - MDX Design Tokens
// Based on MDX Design System: https://mdx.migros.ch

struct MDXColors {
    // Primary brand color (orange/peach from Migros)
    static let primary = Color(red: 1.0, green: 0.4, blue: 0.0) // Orange
    static let primaryLight = Color(red: 1.0, green: 0.9, blue: 0.85) // Light peach
    
    // Neutral colors
    static let textPrimary = Color(hex: "#333333") // #333 for product text
    static let textSecondary = Color.gray
    static let background = Color.white
    static let surface = Color(white: 0.98)
    
    // Semantic colors
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.orange
}

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct MDXSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 40
}

struct MDXTypography {
    // Helvetica Neue font family
    // Try Helvetica Now first, then Helvetica Neue, fallback to system
    static func helveticaNeue(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        // Map Font.Weight to Helvetica Neue font names
        let fontName: String
        switch weight {
        case .bold:
            // Try Helvetica Now Bold first
            if UIFont(name: "HelveticaNowDisplay-Bold", size: size) != nil {
                return Font.custom("HelveticaNowDisplay-Bold", size: size)
            }
            fontName = "HelveticaNeue-Bold"
        case .semibold, .medium:
            // Try Helvetica Now Medium first
            if UIFont(name: "HelveticaNowDisplay-Medium", size: size) != nil {
                return Font.custom("HelveticaNowDisplay-Medium", size: size)
            }
            fontName = weight == .semibold ? "HelveticaNeue-Medium" : "HelveticaNeue-Medium"
        case .regular:
            // Try Helvetica Now Regular first
            if UIFont(name: "HelveticaNowDisplay-Regular", size: size) != nil {
                return Font.custom("HelveticaNowDisplay-Regular", size: size)
            }
            fontName = "HelveticaNeue"
        default:
            fontName = "HelveticaNeue"
        }
        
        // Try Helvetica Neue
        if UIFont(name: fontName, size: size) != nil {
            return Font.custom(fontName, size: size)
        }
        
        // Fallback to system font
        return Font.system(size: size, weight: weight, design: .default)
    }
    
    // Headings
    static let heading1 = helveticaNeue(size: 28, weight: .bold)
    static let heading2 = helveticaNeue(size: 24, weight: .bold)
    static let heading3 = helveticaNeue(size: 20, weight: .semibold)
    
    // Body text
    static let body = helveticaNeue(size: 16, weight: .regular)
    static let bodyMedium = helveticaNeue(size: 16, weight: .medium)
    static let bodySmall = helveticaNeue(size: 14, weight: .regular)
    
    // Button text
    static let button = helveticaNeue(size: 16, weight: .semibold)
    static let buttonSmall = helveticaNeue(size: 14, weight: .semibold)
    
    // Product card specific - with 150% line height
    static let productPrice = helveticaNeue(size: 20, weight: .bold)
    static let productName = helveticaNeue(size: 14, weight: .bold)
    static let productAmount = helveticaNeue(size: 12, weight: .regular)
}

struct MDXCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 20
    static let pill: CGFloat = 30
}

