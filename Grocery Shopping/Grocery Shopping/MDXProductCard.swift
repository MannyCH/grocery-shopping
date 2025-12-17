import SwiftUI

// MARK: - MDX Product Card Component
// Based on MDX Design System: https://mdx.migros.ch/latest/components/patterns/product-card/overview-hdbXerKf

// MARK: - Product Model
// Based on MDX web component structure: https://mdx-storybook.migros.ch/?path=/story/ui-product-card--horizontal
struct Product: Identifiable {
    let id = UUID()
    let productId: String // product-id
    let name: String // name
    let brand: String? // brand
    let productInformation: String? // product-information (weight/unit)
    let price: Double // price
    let originalPrice: Double? // original-price (before price)
    let insteadOf: String? // instead-of (e.g., "statt")
    let imageUrl: String? // image (URL)
    let ratingAverage: Double? // rating-average-all
    let ratingCount: Int? // rating-count-all
    let availability: String // availability (e.g., "available")
    let energyBadgeUrl: String? // energy-badge (image URL)
    let energyBadgeAltText: String? // energy-badge-alt-text
    let hasDiscount: Bool // has-discount
    let discountAmount: String? // discount-amount (e.g., "15%")
    let discountDescription: String? // discount-description
    let cumulusPoints: Int? // cumulus-points
    let badgeDescription: String? // badge-description
    let minimumPieces: Int? // minimum-pieces
    let discountPrice: Double? // discount-price
    let reductionTypeId: String? // reduction-type-id
    let reductionAmount: String? // reduction-amount
    let reductionSuffix: String? // reduction-suffix (e.g., "günstiger")
    let category: ProductCategory // Category for grouping
    
    // Computed properties for convenience
    var badges: [String] {
        var badges: [String] = []
        if hasDiscount, let discount = discountAmount {
            badges.append(discount)
        }
        if let badgeDesc = badgeDescription {
            badges.append(badgeDesc)
        }
        return badges
    }
}

// MARK: - Product Category Enum
enum ProductCategory: String, CaseIterable {
    case dairyAndEggs = "Dairy & Eggs"
    case fruitsAndVegetables = "Fruits & Vegetables"
    case pasta = "Pasta"
    case condimentsAndCanned = "Condiments & Canned Food"
    case bread = "Bread & Bakery"
}

// MARK: - MDX Product Card (Horizontal Layout)
// Based on MDX Storybook: https://mdx-storybook.migros.ch/?path=/story/ui-product-card--horizontal
struct MDXProductCard: View {
    let product: Product
    let onAddToCart: ((Int) -> Void)? // Changed to accept quantity
    let initialQuantity: Int // Initial quantity from basket
    let alwaysShowAddButton: Bool // If true, never show counter - just add button
    @State private var showAddedFeedback = false
    @State private var quantity: Int = 0 // Track quantity for this product
    
    init(product: Product, initialQuantity: Int = 0, alwaysShowAddButton: Bool = false, onAddToCart: ((Int) -> Void)? = nil) {
        self.product = product
        self.initialQuantity = initialQuantity
        self.alwaysShowAddButton = alwaysShowAddButton
        self.onAddToCart = onAddToCart
        self._quantity = State(initialValue: initialQuantity)
    }
    
    
    var body: some View {
        // MDX Horizontal Product Card - Compact design, 100% width, with subtle border
        HStack(alignment: .top, spacing: 12) {
            // Product Image (left) - max 80x80px
            // Product image placeholder - always show icon
            RoundedRectangle(cornerRadius: 0)
                .fill(MDXColors.surface)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: getProductIcon(for: product.name))
                        .font(.system(size: 24))
                        .foregroundColor(MDXColors.textSecondary.opacity(0.4))
                )
            
            // Product Information (right) - Compact layout
            VStack(alignment: .leading, spacing: 0) {
                // Top row: Product Name (left) and Add Button (right)
                HStack(alignment: .top) {
                    // Product Name - 14px, bold, #333
                    Text(product.name)
                        .font(MDXTypography.productName)
                        .foregroundColor(MDXColors.textPrimary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(7) // Additional spacing to approximate 150% line height
                    
                    Spacer()
                    
                    // Quantity Selector or Add Button (top right)
                    // For search results (alwaysShowAddButton = true), always show only the add button
                    if quantity > 0 && !alwaysShowAddButton {
                        // Quantity Selector: Minus, Number, Plus
                        HStack(spacing: 0) {
                            // Minus Button
                            Button(action: {
                                if quantity > 0 {
                                    quantity -= 1
                                    onAddToCart?(quantity)
                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.impactOccurred()
                                }
                            }) {
                                Image(systemName: "minus")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(MDXColors.textPrimary)
                                    .frame(width: 32, height: 32)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Quantity Number
                            Text("\(quantity)")
                                .font(MDXTypography.helveticaNeue(size: 16, weight: .bold))
                                .foregroundColor(MDXColors.textPrimary)
                                .frame(minWidth: 40)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(MDXColors.background)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            
                            // Plus Button (light grey background)
                            Button(action: {
                                quantity += 1
                                onAddToCart?(quantity)
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(MDXColors.textPrimary)
                                    .frame(width: 32, height: 32)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        // Add Button - Black plus icon (initial state)
                        Button(action: {
                            onAddToCart?(1) // Always add 1
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            
                            // For search results, keep showing add button (don't update quantity)
                            if !alwaysShowAddButton {
                                quantity = 1
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    // Transition to quantity selector
                                }
                            }
                            // If alwaysShowAddButton is true, quantity stays 0 so add button stays visible
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("Add to cart")
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.top, 0)
                
                // Bottom row: Price and Amount (close together)
                HStack(alignment: .center, spacing: 8) {
                    // Price - 20px, bold, #333
                    Text(String(format: "%.2f", product.price))
                        .font(MDXTypography.productPrice)
                        .foregroundColor(MDXColors.textPrimary)
                        .lineLimit(1)
                    
                    // Weight/Amount - 12px, regular, #333, placed next to price
                    if let productInfo = product.productInformation {
                        let weight = extractWeight(from: productInfo)
                        if !weight.isEmpty {
                            Text(weight)
                                .font(MDXTypography.productAmount)
                                .foregroundColor(MDXColors.textPrimary)
                                .lineLimit(1)
                        } else {
                            Text(productInfo)
                                .font(MDXTypography.productAmount)
                                .foregroundColor(MDXColors.textPrimary)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(MDXColors.background)
        .overlay(alignment: .bottom) {
            // Subtle grey border at the bottom - one per list item
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
        .onAppear {
            // Reset quantity to initialQuantity when view appears (fixes scroll recycling issue)
            quantity = initialQuantity
        }
        .onChange(of: initialQuantity) { newValue in
            // Update quantity if initialQuantity changes
            quantity = newValue
        }
    }
    
    // Helper to extract weight from product information
    private func extractWeight(from info: String) -> String {
        // Look for patterns like "150g", "1L", "500g", etc.
        let patterns = [
            "\\d+\\s*g",  // e.g., "150g", "500 g"
            "\\d+\\s*kg", // e.g., "1kg", "2 kg"
            "\\d+\\s*L",  // e.g., "1L", "2 L"
            "\\d+\\s*ml", // e.g., "500ml", "250 ml"
        ]
        
        for pattern in patterns {
            if let range = info.range(of: pattern, options: .regularExpression) {
                return String(info[range])
            }
        }
        return ""
    }
    
    // Helper function to get appropriate icon for product
    private func getProductIcon(for productName: String) -> String {
        let name = productName.lowercased()
        if name.contains("milk") {
            return "drop.fill"
        } else if name.contains("bread") {
            return "square.fill"
        } else if name.contains("egg") {
            return "circle.fill"
        } else if name.contains("cheese") || name.contains("yogurt") {
            return "square.fill"
        } else if name.contains("banana") || name.contains("apple") || name.contains("orange") || name.contains("strawberr") {
            return "leaf.fill"
        } else if name.contains("tomato") || name.contains("carrot") || name.contains("lettuce") {
            return "leaf.fill"
        }
        return "photo"
    }
}

// MARK: - Energy Badge View
struct EnergyBadgeView: View {
    let energyClass: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Energy class letter (large, white)
            Text(energyClass)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color.green)
            
            // Energy scale (A-G)
            VStack(spacing: 1) {
                ForEach(["A", "B", "C", "D", "E", "F", "G"].reversed(), id: \.self) { letter in
                    Rectangle()
                        .fill(letter == energyClass ? Color.green : Color.gray.opacity(0.3))
                        .frame(width: 24, height: 3)
                }
            }
        }
        .frame(width: 24, height: 40)
        .background(Color.white)
        .cornerRadius(2)
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        )
    }
}

// MARK: - Preview
struct MDXProductCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: MDXSpacing.md) {
            MDXProductCard(
                product: Product(
                    productId: "104041100001",
                    name: "Semi-skimmed Milk",
                    brand: "Migros",
                    productInformation: "1L für eine Flasche von diesem Produkt",
                    price: 2.80,
                    originalPrice: 3.20,
                    insteadOf: "statt",
                    imageUrl: nil,
                    ratingAverage: 4.5,
                    ratingCount: 12,
                    availability: "available",
                    energyBadgeUrl: nil,
                    energyBadgeAltText: nil,
                    hasDiscount: true,
                    discountAmount: "15%",
                    discountDescription: "Sale",
                    cumulusPoints: 5,
                    badgeDescription: "Bio",
                    minimumPieces: nil,
                    discountPrice: nil,
                    reductionTypeId: "01",
                    reductionAmount: "5",
                    reductionSuffix: "günstiger",
                    category: .dairyAndEggs
                ),
                onAddToCart: { _ in }
            )
            
            MDXProductCard(
                product: Product(
                    productId: "104041100002",
                    name: "Whole Milk",
                    brand: "Migros",
                    productInformation: "1L für eine Flasche von diesem Produkt",
                    price: 2.50,
                    originalPrice: nil,
                    insteadOf: nil,
                    imageUrl: nil,
                    ratingAverage: 4.2,
                    ratingCount: 8,
                    availability: "available",
                    energyBadgeUrl: nil,
                    energyBadgeAltText: "A",
                    hasDiscount: false,
                    discountAmount: nil,
                    discountDescription: nil,
                    cumulusPoints: nil,
                    badgeDescription: "New",
                    minimumPieces: nil,
                    discountPrice: nil,
                    reductionTypeId: nil,
                    reductionAmount: nil,
                    reductionSuffix: nil,
                    category: .dairyAndEggs
                ),
                onAddToCart: { _ in }
            )
        }
        .padding()
        .previewDevice("iPhone 14 Pro")
    }
}

