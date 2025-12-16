import SwiftUI

// MARK: - Shopping List View (In-Store Mode)
struct ShoppingListView: View {
    @Binding var isOnline: Bool // Binding to control toggle
    @State private var selectedPeriod = "Weekly"
    @State private var newItemText = ""
    @State private var planningItems: [ShoppingListItem] = []
    @State private var doneItems: [ShoppingListItem] = []
    @FocusState private var isAddingItem: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ShoppingListHeader(isOnline: $isOnline, selectedPeriod: $selectedPeriod)
            
            Divider()
            
            // Store Banner
            StoreBanner()
            
            // Shopping List Content
            ScrollView {
                VStack(spacing: 0) {
                    // Planning Section
                    VStack(alignment: .leading, spacing: MDXSpacing.sm) {
                        Text("Planning")
                            .font(MDXTypography.heading3)
                            .foregroundColor(MDXColors.textSecondary)
                            .padding(.horizontal, MDXSpacing.md)
                            .padding(.top, MDXSpacing.lg)
                            .padding(.bottom, MDXSpacing.sm)
                        
                        // Add item field (always first)
                        HStack(spacing: MDXSpacing.md) {
                            TextField("enter here to add item", text: $newItemText)
                                .font(MDXTypography.body)
                                .foregroundColor(MDXColors.textPrimary)
                                .focused($isAddingItem)
                                .submitLabel(.done)
                                .onSubmit {
                                    addItem()
                                }
                            
                            Spacer()
                            
                            // Find product button (disabled when empty)
                            Button(action: {}) {
                                Text("Find product")
                                    .font(MDXTypography.bodySmall)
                                    .foregroundColor(newItemText.isEmpty ? MDXColors.textSecondary : MDXColors.primary)
                                    .padding(.horizontal, MDXSpacing.md)
                                    .padding(.vertical, MDXSpacing.sm)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: MDXCornerRadius.pill)
                                            .stroke(newItemText.isEmpty ? Color.gray.opacity(0.3) : MDXColors.primary, lineWidth: 1)
                                    )
                            }
                            .disabled(newItemText.isEmpty)
                            
                            // Radio button (unchecked)
                            Image(systemName: "circle")
                                .font(.system(size: 24))
                                .foregroundColor(MDXColors.textSecondary)
                        }
                        .padding(.horizontal, MDXSpacing.md)
                        .padding(.vertical, MDXSpacing.md)
                        .background(MDXColors.background)
                        
                        Divider()
                        
                        // Planning items
                        ForEach(planningItems) { item in
                            ShoppingListItemRow(
                                item: item,
                                onToggle: {
                                    toggleItem(item)
                                }
                            )
                            Divider()
                        }
                    }
                    
                    // Done Section
                    if !doneItems.isEmpty {
                        VStack(alignment: .leading, spacing: MDXSpacing.sm) {
                            Text("Done")
                                .font(MDXTypography.heading3)
                                .foregroundColor(MDXColors.textSecondary)
                                .padding(.horizontal, MDXSpacing.md)
                                .padding(.top, MDXSpacing.lg)
                                .padding(.bottom, MDXSpacing.sm)
                            
                            ForEach(doneItems) { item in
                                ShoppingListItemRow(
                                    item: item,
                                    onToggle: {
                                        toggleItem(item)
                                    }
                                )
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .background(MDXColors.background)
    }
    
    private func addItem() {
        guard !newItemText.isEmpty else { return }
        let newItem = ShoppingListItem(name: newItemText, isDone: false)
        planningItems.append(newItem)
        newItemText = ""
        // Keep keyboard active and field focused
        isAddingItem = true
    }
    
    private func toggleItem(_ item: ShoppingListItem) {
        if let index = planningItems.firstIndex(where: { $0.id == item.id }) {
            var updatedItem = item
            updatedItem.isDone = true
            planningItems.remove(at: index)
            doneItems.append(updatedItem)
        } else if let index = doneItems.firstIndex(where: { $0.id == item.id }) {
            var updatedItem = item
            updatedItem.isDone = false
            doneItems.remove(at: index)
            planningItems.append(updatedItem)
        }
    }
}

// MARK: - Shopping List Header
struct ShoppingListHeader: View {
    @Binding var isOnline: Bool // Binding to control toggle
    @Binding var selectedPeriod: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Toggle Button and Menu (top row)
            HStack {
                HStack(spacing: 0) {
                    // In-store button
                    Button(action: {
                        isOnline = false
                    }) {
                        Text("In-Store")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(isOnline ? MDXColors.textPrimary : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(isOnline ? Color.clear : MDXColors.primary)
                    }
                    
                    // Online button
                    Button(action: {
                        isOnline = true
                    }) {
                        Text("Online")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(isOnline ? .white : MDXColors.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(isOnline ? MDXColors.primary : Color.clear)
                    }
                }
                .background(MDXColors.primaryLight)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(MDXColors.primary, lineWidth: 1.5)
                )
                .frame(width: 140)
                
                Spacer()
                
                // More options (top right)
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(MDXColors.textPrimary)
                }
            }
            .padding(.horizontal, MDXSpacing.md)
            .padding(.top, MDXSpacing.md)
            .padding(.bottom, MDXSpacing.sm)
            .background(MDXColors.primaryLight)
            
            // Title and Dropdown (bottom row)
            HStack(alignment: .center, spacing: MDXSpacing.md) {
                // Title - MDX Typography
                Text("Shopping list")
                    .font(MDXTypography.heading1)
                    .foregroundColor(MDXColors.textPrimary)
                
                Spacer()
                
                // Period Selector - MDX Quaternary style (right-aligned)
                Button(action: {}) {
                    HStack(spacing: MDXSpacing.sm) {
                        Text(selectedPeriod)
                            .font(MDXTypography.bodyMedium)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(MDXColors.textPrimary)
                    .padding(.horizontal, MDXSpacing.md)
                    .padding(.vertical, MDXSpacing.sm)
                    .background(MDXColors.surface)
                    .cornerRadius(MDXCornerRadius.pill)
                }
            }
            .padding(.horizontal, MDXSpacing.md)
            .padding(.bottom, MDXSpacing.md)
            .background(MDXColors.primaryLight)
        }
    }
}

// MARK: - Store Banner
struct StoreBanner: View {
    var body: some View {
        HStack(spacing: MDXSpacing.sm) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text("Preise & Verfügbarkeit für:")
                        .font(MDXTypography.bodySmall)
                        .foregroundColor(MDXColors.textPrimary)
                }
                
                HStack(spacing: 6) {
                    Text("Migros Ittigen, 3063")
                        .font(MDXTypography.bodyMedium)
                        .foregroundColor(MDXColors.textPrimary)
                    
                    Button(action: {}) {
                        Text("ändern")
                            .font(MDXTypography.bodySmall)
                            .foregroundColor(MDXColors.primary)
                            .underline()
                    }
                }
            }
            
            Spacer()
            
            // Opening times (right side)
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                
                Text("Offen bis 19h")
                    .font(MDXTypography.bodySmall)
                    .foregroundColor(Color.green)
            }
        }
        .padding(.horizontal, MDXSpacing.md)
        .padding(.vertical, MDXSpacing.md)
        .background(Color(red: 0.95, green: 0.9, blue: 0.85))
    }
}

// MARK: - Shopping List Item Model
struct ShoppingListItem: Identifiable {
    let id = UUID()
    let name: String
    var isDone: Bool
}

// MARK: - Stacked Cards View
struct StackedCardsView: View {
    let basketItems: [BasketItem]
    let sampleProducts: [Product]
    let onQuantityChange: (String, Int) -> Void
    private let maxVisibleCards = 3 // Show top 3 items
    
    var body: some View {
        ZStack {
            // Show stacked cards (from back to front)
            ForEach(Array(basketItems.suffix(maxVisibleCards).enumerated().reversed()), id: \.element.id) { index, item in
                if let product = sampleProducts.first(where: { $0.name == item.name }) {
                    let cardIndex = basketItems.suffix(maxVisibleCards).count - 1 - index
                    let isTopCard = cardIndex == 0
                    
                    AddedProductRow(
                        product: product,
                        quantity: item.quantity,
                        alwaysShowControls: isTopCard, // Only top card shows controls
                        onQuantityChange: { newQty in
                            onQuantityChange(product.name, newQty)
                        }
                    )
                    .opacity(isTopCard ? 1.0 : 0.7) // Fade cards behind
                    .scaleEffect(isTopCard ? 1.0 : 0.95) // Slightly smaller cards behind
                    .offset(y: CGFloat(cardIndex) * -8) // Stack offset
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
        }
        .padding(.bottom, CGFloat((basketItems.suffix(maxVisibleCards).count - 1)) * 8) // Compensate for negative offset
    }
}

// MARK: - Shopping List Item Row
struct ShoppingListItemRow: View {
    let item: ShoppingListItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: MDXSpacing.md) {
            Text(item.name)
                .font(MDXTypography.body)
                .foregroundColor(MDXColors.textPrimary)
                .strikethrough(item.isDone, color: MDXColors.textPrimary) // Cross out if done
            
            Spacer()
            
            // Find product button (hidden when done)
            if !item.isDone {
                Button(action: {}) {
                    Text("Find product")
                        .font(MDXTypography.bodySmall)
                        .foregroundColor(MDXColors.primary)
                        .padding(.horizontal, MDXSpacing.md)
                        .padding(.vertical, MDXSpacing.sm)
                        .overlay(
                            RoundedRectangle(cornerRadius: MDXCornerRadius.pill)
                                .stroke(MDXColors.primary, lineWidth: 1)
                        )
                }
            }
            
            // Radio button (checked when done)
            Button(action: onToggle) {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(item.isDone ? MDXColors.primary : MDXColors.textPrimary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, MDXSpacing.md)
        .padding(.vertical, MDXSpacing.md)
        .background(MDXColors.background)
    }
}

struct BasketView: View {
    @State private var selectedPeriod = "Weekly"
    @State private var showAddProduct = false
    @State private var searchText = ""
    @State private var scrollOffset: CGFloat = 0
    @FocusState private var isSearchFocused: Bool // Track if search field is focused
    @State private var showSearchContainer = false // Track if search container should be visible
    @State private var isOnline = true // Track In-Store vs Online toggle
    private let scrollThreshold: CGFloat = 50 // When to show compact header
    
    // Mock basket items for demonstration - Start empty
    @State private var basketItems: [BasketItem] = []
    
    // Favorite product IDs (shown when search is activated but empty)
    private let favoriteProductIds = ["104041100011", "104041100012", "104041100050", "104041100020"] // Bananas, Apples, Orange Juice, Eggs
    
    // Computed property for favorite products
    var favoriteProducts: [Product] {
        sampleProducts.filter { favoriteProductIds.contains($0.productId) }
    }
    
    // Sample products for search - Using MDX web component structure
    let sampleProducts: [Product] = [
        // Dairy Products - Multiple Milk Varieties (at least 3+ for "milk" search)
        Product(productId: "104041100001", name: "Semi-skimmed Milk", brand: "Migros", productInformation: "1L für eine Flasche von diesem Produkt", price: 2.80, originalPrice: 3.20, insteadOf: "statt", imageUrl: nil, ratingAverage: 4.5, ratingCount: 12, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: true, discountAmount: "15%", discountDescription: "Sale", cumulusPoints: 5, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: "01", reductionAmount: "5", reductionSuffix: "günstiger", category: .dairyAndEggs),
        Product(productId: "104041100002", name: "Whole Milk", brand: "Migros", productInformation: "1L für eine Flasche von diesem Produkt", price: 2.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.2, ratingCount: 8, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: "A", hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "New", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100003", name: "Bio Milk", brand: "Migros Bio", productInformation: "1L für eine Flasche von diesem Produkt", price: 3.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.8, ratingCount: 25, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: "A", hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 10, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100004", name: "Lactose-free Milk", brand: "Migros", productInformation: "1L für eine Flasche von diesem Produkt", price: 3.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.3, ratingCount: 15, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100005", name: "Skimmed Milk", brand: "Migros", productInformation: "1L für eine Flasche von diesem Produkt", price: 2.40, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.1, ratingCount: 6, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: "A", hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100006", name: "Chocolate Milk", brand: "Migros", productInformation: "500ml für eine Flasche von diesem Produkt", price: 3.80, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.6, ratingCount: 18, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "New", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100007", name: "Almond Milk", brand: "Migros", productInformation: "1L für eine Flasche von diesem Produkt", price: 4.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.4, ratingCount: 9, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100008", name: "Oat Milk", brand: "Migros Bio", productInformation: "1L für eine Flasche von diesem Produkt", price: 3.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.7, ratingCount: 22, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 8, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100009", name: "Greek Yogurt", brand: "Migros", productInformation: "500g für eine Packung von diesem Produkt", price: 4.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.6, ratingCount: 14, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100010", name: "Swiss Cheese", brand: "Migros", productInformation: "200g für eine Packung von diesem Produkt", price: 8.90, originalPrice: 9.90, insteadOf: "statt", imageUrl: nil, ratingAverage: 4.7, ratingCount: 31, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: true, discountAmount: "10%", discountDescription: "Sale", cumulusPoints: 15, badgeDescription: "Sale", minimumPieces: nil, discountPrice: nil, reductionTypeId: "01", reductionAmount: "5", reductionSuffix: "günstiger", category: .dairyAndEggs),
        
        // Fruits
        Product(productId: "104041100011", name: "Bananas", brand: nil, productInformation: "1kg für eine Packung von diesem Produkt", price: 3.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.4, ratingCount: 45, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        Product(productId: "104041100012", name: "Apples", brand: nil, productInformation: "1kg für eine Packung von diesem Produkt", price: 2.80, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.5, ratingCount: 38, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        Product(productId: "104041100013", name: "Strawberries", brand: nil, productInformation: "250g für eine Packung von diesem Produkt", price: 5.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.8, ratingCount: 52, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        Product(productId: "104041100014", name: "Oranges", brand: nil, productInformation: "1kg für eine Packung von diesem Produkt", price: 3.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.3, ratingCount: 27, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        Product(productId: "104041100050", name: "Orange Juice", brand: "Migros", productInformation: "1L für eine Flasche von diesem Produkt", price: 4.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.6, ratingCount: 78, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 8, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        
        // Vegetables
        Product(productId: "104041100015", name: "Tomatoes", brand: nil, productInformation: "500g für eine Packung von diesem Produkt", price: 4.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.2, ratingCount: 19, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        Product(productId: "104041100016", name: "Carrots", brand: nil, productInformation: "1kg für eine Packung von diesem Produkt", price: 2.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.1, ratingCount: 11, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        Product(productId: "104041100017", name: "Lettuce", brand: nil, productInformation: "1 Stück von diesem Produkt", price: 2.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.0, ratingCount: 7, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        
        // Bread & Bakery
        Product(productId: "104041100018", name: "White Bread", brand: "Migros", productInformation: "500g für eine Stange von diesem Produkt", price: 2.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.3, ratingCount: 33, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .bread),
        Product(productId: "104041100019", name: "Whole Grain Bread", brand: "Migros", productInformation: "500g für eine Stange von diesem Produkt", price: 3.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.6, ratingCount: 41, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 6, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .bread),
        
        // Eggs
        Product(productId: "104041100020", name: "Free Range Eggs", brand: "Migros", productInformation: "6 Stück von diesem Produkt", price: 5.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.7, ratingCount: 67, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 12, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100021", name: "Organic Eggs", brand: "Migros Bio", productInformation: "6 Stück von diesem Produkt", price: 6.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.9, ratingCount: 89, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 15, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        
        // Potatoes (various types)
        Product(productId: "104041100022", name: "Migros Fresca Potatoes Waxy", brand: "Migros", productInformation: "1kg für eine Packung von diesem Produkt", price: 2.95, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.4, ratingCount: 28, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        Product(productId: "104041100023", name: "Migros Fresca Potatoes Floury Cooking", brand: "Migros", productInformation: "1kg für eine Packung von diesem Produkt", price: 2.95, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.5, ratingCount: 32, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        Product(productId: "104041100024", name: "Organic Potatoes", brand: "Migros Bio", productInformation: "1kg für eine Packung von diesem Produkt", price: 3.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.6, ratingCount: 41, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 8, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        Product(productId: "104041100025", name: "Sweet Potatoes", brand: "Migros", productInformation: "750g für eine Packung von diesem Produkt", price: 4.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.7, ratingCount: 37, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        
        // Leeks (various types)
        Product(productId: "104041100026", name: "Leeks Pole", brand: "Migros", productInformation: "500g für eine Packung von diesem Produkt", price: 3.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.2, ratingCount: 18, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        Product(productId: "104041100027", name: "Leeks Green", brand: "Migros", productInformation: "500g für eine Packung von diesem Produkt", price: 3.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.3, ratingCount: 22, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        Product(productId: "104041100028", name: "Bio Leeks Green", brand: "Migros Bio", productInformation: "500g für eine Packung von diesem Produkt", price: 4.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.5, ratingCount: 29, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 10, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .fruitsAndVegetables),
        
        // Cream (various types)
        Product(productId: "104041100029", name: "Full Cream", brand: "Migros", productInformation: "500ml für eine Packung von diesem Produkt", price: 4.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.6, ratingCount: 45, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100030", name: "Half Cream", brand: "Migros", productInformation: "500ml für eine Packung von diesem Produkt", price: 3.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.4, ratingCount: 38, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100031", name: "Cooking Cream", brand: "Migros", productInformation: "250ml für eine Packung von diesem Produkt", price: 2.80, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.3, ratingCount: 26, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100032", name: "Whipping Cream", brand: "Migros", productInformation: "250ml für eine Packung von diesem Produkt", price: 3.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.7, ratingCount: 52, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100033", name: "Bio Full Cream", brand: "Migros Bio", productInformation: "500ml für eine Packung von diesem Produkt", price: 5.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.8, ratingCount: 34, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 12, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        
        // Garlic (various types)
        Product(productId: "104041100034", name: "Fresh Garlic", brand: "Migros", productInformation: "250g für eine Packung von diesem Produkt", price: 2.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.4, ratingCount: 31, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .condimentsAndCanned),
        Product(productId: "104041100035", name: "Bio Garlic", brand: "Migros Bio", productInformation: "200g für eine Packung von diesem Produkt", price: 3.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.6, ratingCount: 27, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 8, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .condimentsAndCanned),
        Product(productId: "104041100036", name: "Garlic Cloves", brand: "Migros", productInformation: "150g für eine Packung von diesem Produkt", price: 2.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.3, ratingCount: 19, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .condimentsAndCanned),
        Product(productId: "104041100037", name: "Minced Garlic", brand: "Migros", productInformation: "100g für ein Glas von diesem Produkt", price: 3.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.1, ratingCount: 15, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .condimentsAndCanned),
        
        // Butter (various types)
        Product(productId: "104041100038", name: "Butter Salted", brand: "Migros", productInformation: "250g für eine Packung von diesem Produkt", price: 4.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.5, ratingCount: 48, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100039", name: "Butter Unsalted", brand: "Migros", productInformation: "250g für eine Packung von diesem Produkt", price: 4.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.6, ratingCount: 52, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100040", name: "Bio Butter", brand: "Migros Bio", productInformation: "250g für eine Packung von diesem Produkt", price: 5.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.8, ratingCount: 61, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 15, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100041", name: "Herb Butter", brand: "Migros", productInformation: "150g für eine Packung von diesem Produkt", price: 3.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.4, ratingCount: 35, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs),
        Product(productId: "104041100042", name: "Garlic Butter", brand: "Migros", productInformation: "150g für eine Packung von diesem Produkt", price: 3.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.3, ratingCount: 29, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil, category: .dairyAndEggs)
    ]
    
    // Filtered products based on search
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return []
        }
        return sampleProducts.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            ($0.brand?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    // Filtered basket items based on search
    var filteredBasketItems: [BasketItem] {
        if searchText.isEmpty {
            return basketItems
        }
        return basketItems.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        // Switch between Shopping List (In-Store) and Basket (Online)
        if isOnline {
            // Online mode - Show Basket
            basketView
        } else {
            // In-Store mode - Show Shopping List
            ShoppingListView(isOnline: $isOnline)
        }
    }
    
    private var basketView: some View {
        VStack(spacing: 0) {
            // Custom Header - Hide when search container is visible
            if !showSearchContainer {
                CustomHeaderView(
                    isOnline: $isOnline,
                    selectedPeriod: $selectedPeriod,
                    isCompact: scrollOffset > scrollThreshold
                )
                
                Divider()
            }
            
            // Main content area
            if !showSearchContainer {
                // Content Area with scroll detection (when not searching)
                ScrollView {
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)
                    if basketItems.isEmpty {
                        // Empty State Content (when basket is empty and no search)
                        VStack(spacing: MDXSpacing.lg) {
                            // Illustration
                            EmptyBasketIllustration()
                                .padding(.top, MDXSpacing.xxl)
                            
                            // Text Content - MDX Typography
                            VStack(spacing: MDXSpacing.md) {
                                Text("Fill your basket")
                                    .font(MDXTypography.heading1)
                                    .foregroundColor(MDXColors.textPrimary)
                                
                                Text("Add products while browsing or use the search field below.")
                                    .font(MDXTypography.body)
                                    .foregroundColor(MDXColors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, MDXSpacing.xl)
                                
                                Text("Switch to the shopping list at any time to use it to shop.")
                                    .font(MDXTypography.body)
                                    .foregroundColor(MDXColors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, MDXSpacing.xl)
                            }
                            .padding(.top, MDXSpacing.xl)
                            .padding(.bottom, MDXSpacing.xxl)
                        }
                    } else {
                        // Basket with items (no search) - Grouped by category
                        ScrollView {
                            VStack(spacing: 0) {
                                // Group basket items by category
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    let categoryItems = basketItems.compactMap { item -> (BasketItem, Product)? in
                                        guard let product = sampleProducts.first(where: { $0.name == item.name }),
                                              product.category == category else {
                                            return nil
                                        }
                                        return (item, product)
                                    }
                                    
                                    if !categoryItems.isEmpty {
                                        // Category Header
                                        Text(category.rawValue)
                                            .font(MDXTypography.heading3)
                                            .foregroundColor(MDXColors.textPrimary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, MDXSpacing.md)
                                            .padding(.top, MDXSpacing.lg)
                                            .padding(.bottom, MDXSpacing.sm)
                                            .background(MDXColors.surface)
                                        
                                        // Category Items
                                        ForEach(categoryItems, id: \.0.id) { (item, product) in
                                            AddedProductRow(
                                                product: product,
                                                quantity: item.quantity,
                                                alwaysShowControls: false, // Collapsible in basket list
                                                onQuantityChange: { newQty in
                                                    if let existingIndex = basketItems.firstIndex(where: { $0.name == product.name }) {
                                                        if newQty > 0 {
                                                            let updatedItem = BasketItem(
                                                                name: product.name,
                                                                quantity: newQty,
                                                                price: product.price
                                                            )
                                                            basketItems[existingIndex] = updatedItem
                                                        } else {
                                                            basketItems.remove(at: existingIndex)
                                                        }
                                                    }
                                                }
                                            )
                                            Divider()
                                        }
                                    }
                                }
                            }
                            .padding(.top, MDXSpacing.sm)
                        }
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = -value
                }
            } else {
                // Search mode - Activated when search field is focused
                VStack(spacing: 0) {
                    // Show stacked cards of last added items at top
                    if !basketItems.isEmpty {
                        VStack(spacing: 0) {
                            StackedCardsView(
                                basketItems: basketItems,
                                sampleProducts: sampleProducts,
                                onQuantityChange: { productName, newQty in
                                    if let existingIndex = basketItems.firstIndex(where: { $0.name == productName }) {
                                        if newQty > 0 {
                                            let updatedItem = BasketItem(
                                                name: productName,
                                                quantity: newQty,
                                                price: basketItems[existingIndex].price
                                            )
                                            basketItems[existingIndex] = updatedItem
                                        } else {
                                            basketItems.remove(at: existingIndex)
                                        }
                                    }
                                }
                            )
                            
                            // Divider below stacked cards
                            Divider()
                                .padding(.bottom, MDXSpacing.sm)
                        }
                        .background(MDXColors.background)
                    }
                    
                    // "Search" heading (even smaller)
                    Text("Search")
                        .font(MDXTypography.bodyMedium) // Using bodyMedium for smaller size
                        .foregroundColor(MDXColors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, MDXSpacing.md)
                        .padding(.top, MDXSpacing.sm)
                        .padding(.bottom, MDXSpacing.xs)
                    
                    // Search Results Container - Expands to fill available space
                    VStack(spacing: 0) {
                        ScrollView {
                            if searchText.isEmpty {
                                // Show favorite products when search is activated but empty
                                LazyVStack(spacing: 0) {
                                    // "favorites" caption
                                    Text("favorites")
                                        .font(MDXTypography.bodySmall)
                                        .foregroundColor(MDXColors.textSecondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 16)
                                        .padding(.top, MDXSpacing.md)
                                        .padding(.bottom, MDXSpacing.sm)
                                    
                                    // Show favorite products
                                    ForEach(favoriteProducts) { product in
                                        MDXProductCard(
                                            product: product,
                                            initialQuantity: 0, // Always start with + button
                                            onAddToCart: { qty in
                                                if let existingIndex = basketItems.firstIndex(where: { $0.name == product.name }) {
                                                    if qty > 0 {
                                                        let updatedItem = BasketItem(
                                                            name: product.name,
                                                            quantity: qty,
                                                            price: product.price
                                                        )
                                                        basketItems[existingIndex] = updatedItem
                                                    } else {
                                                        basketItems.remove(at: existingIndex)
                                                    }
                                                } else if qty > 0 {
                                                    let newItem = BasketItem(
                                                        name: product.name,
                                                        quantity: qty,
                                                        price: product.price
                                                    )
                                                    basketItems.append(newItem)
                                                    // Don't clear search text for favorites - just added
                                                }
                                            }
                                        )
                                        .id(product.productId) // Force recreation to avoid state bugs
                                        
                                        Divider()
                                    }
                                }
                            } else if filteredProducts.isEmpty {
                                // No results state (when searching but nothing found)
                                VStack(spacing: MDXSpacing.md) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 48))
                                        .foregroundColor(MDXColors.textSecondary.opacity(0.5))
                                        .padding(.top, MDXSpacing.xxl)
                                    
                                    Text("No products found")
                                        .font(MDXTypography.heading3)
                                        .foregroundColor(MDXColors.textPrimary)
                                    
                                    Text("Try a different search term")
                                        .font(MDXTypography.body)
                                        .foregroundColor(MDXColors.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, MDXSpacing.xxl)
                            } else {
                                // Product cards list (MDX horizontal layout) - No spacing, full width
                                LazyVStack(spacing: 0) {
                                    // "my top products" caption before first item
                                    if !filteredProducts.isEmpty {
                                        Text("my top products")
                                            .font(MDXTypography.bodySmall)
                                            .foregroundColor(MDXColors.textSecondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 16)
                                            .padding(.top, MDXSpacing.md)
                                            .padding(.bottom, MDXSpacing.sm)
                                        
                                        // First product - always start with 0 quantity
                                        MDXProductCard(
                                            product: filteredProducts[0],
                                            initialQuantity: 0, // Always start with + button
                                            onAddToCart: { qty in
                                                // Update or add product to basket
                                                if let existingIndex = basketItems.firstIndex(where: { $0.name == filteredProducts[0].name }) {
                                                    // Update existing item quantity
                                                    if qty > 0 {
                                                        // Replace the item with updated quantity
                                                        let updatedItem = BasketItem(
                                                            name: filteredProducts[0].name,
                                                            quantity: qty,
                                                            price: filteredProducts[0].price
                                                        )
                                                        basketItems[existingIndex] = updatedItem
                                                    } else {
                                                        // Remove if quantity is 0
                                                        basketItems.remove(at: existingIndex)
                                                    }
                                                } else if qty > 0 {
                                                    // Add new item
                                                    let newItem = BasketItem(
                                                        name: filteredProducts[0].name,
                                                        quantity: qty,
                                                        price: filteredProducts[0].price
                                                    )
                                                    basketItems.append(newItem)
                                                    // Clear search text after adding (keeps container visible)
                                                    searchText = ""
                                                }
                                            }
                                        )
                                        .id(filteredProducts[0].productId) // Force recreation when product changes
                                        
                                        // "found products" caption with "search more" link
                                        HStack(alignment: .center, spacing: MDXSpacing.sm) {
                                            Text("found products")
                                                .font(MDXTypography.bodySmall)
                                                .foregroundColor(MDXColors.textSecondary)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                // Action for search more - could open full search or filter
                                                // For now, just a placeholder
                                            }) {
                                                Text("search more")
                                                    .font(MDXTypography.bodySmall)
                                                    .foregroundColor(MDXColors.primary)
                                                    .underline()
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.top, MDXSpacing.md)
                                        .padding(.bottom, MDXSpacing.sm)
                                        
                                        // Remaining products (skip first one)
                                        ForEach(Array(filteredProducts.enumerated()), id: \.element.id) { index, product in
                                            if index > 0 {
                                                MDXProductCard(
                                                    product: product,
                                                    initialQuantity: 0, // Always start with + button
                                                    onAddToCart: { qty in
                                                        // Update or add product to basket
                                                        if let existingIndex = basketItems.firstIndex(where: { $0.name == product.name }) {
                                                            // Update existing item quantity
                                                            if qty > 0 {
                                                                // Replace the item with updated quantity
                                                                let updatedItem = BasketItem(
                                                                    name: product.name,
                                                                    quantity: qty,
                                                                    price: product.price
                                                                )
                                                                basketItems[existingIndex] = updatedItem
                                                            } else {
                                                                // Remove if quantity is 0
                                                                basketItems.remove(at: existingIndex)
                                                            }
                                                        } else if qty > 0 {
                                                            // Add new item
                                                            let newItem = BasketItem(
                                                                name: product.name,
                                                                quantity: qty,
                                                                price: product.price
                                                            )
                                                            basketItems.append(newItem)
                                                            // Clear search text after adding (keeps container visible)
                                                            searchText = ""
                                                        }
                                                    }
                                                )
                                                .id(product.productId) // Force recreation when product changes
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, MDXSpacing.sm)
                            }
                        }
                        .frame(maxHeight: .infinity) // Expand to fill available space
                        .background(Color(white: 0.95)) // Light grey background for search container
                    }
                }
            }
            
            // Search Field - Fixed at bottom of screen
            VStack(spacing: 0) {
                // Top border
                Divider()
                
                HStack(spacing: MDXSpacing.sm) {
                    // Search field
                    MDXSearchField(
                        text: $searchText,
                        placeholder: "add products",
                        onSubmit: {
                            // Dismiss keyboard when Enter is pressed
                            isSearchFocused = false
                        },
                        focused: $isSearchFocused
                    )
                    .onChange(of: isSearchFocused) { newValue in
                        // When field gets focus, show search container
                        if newValue {
                            showSearchContainer = true
                        }
                    }
                    
                    // Cancel button (appears when search container is visible)
                    if showSearchContainer {
                        Button(action: {
                            // Clear search and dismiss search container
                            searchText = ""
                            isSearchFocused = false
                            showSearchContainer = false
                        }) {
                            Text("Cancel")
                                .font(MDXTypography.body)
                                .foregroundColor(MDXColors.primary)
                        }
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, MDXSpacing.md)
                .padding(.vertical, MDXSpacing.md)
                .background(MDXColors.background)
            }
        }
        .background(MDXColors.background)
        .sheet(isPresented: $showAddProduct) {
            AddProductView()
        }
    }
}

struct CustomHeaderView: View {
    @Binding var isOnline: Bool // Lift state up to BasketView
    @Binding var selectedPeriod: String
    let isCompact: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if isCompact {
                // Compact header (when scrolled)
                HStack(alignment: .center, spacing: MDXSpacing.md) {
                    // Toggle Button (smaller)
                    HStack(spacing: 0) {
                        Button(action: { isOnline = false }) {
                            Text("In-store")
                                .font(MDXTypography.helveticaNeue(size: 12, weight: .medium))
                                .foregroundColor(isOnline ? MDXColors.textPrimary : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(isOnline ? Color.clear : MDXColors.primary)
                        }
                        
                        Button(action: { isOnline = true }) {
                            Text("Online")
                                .font(MDXTypography.helveticaNeue(size: 12, weight: .medium))
                                .foregroundColor(isOnline ? .white : MDXColors.textPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(isOnline ? MDXColors.primary : Color.clear)
                        }
                    }
                    .background(MDXColors.primaryLight)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(MDXColors.primary, lineWidth: 1)
                    )
                    .frame(width: 120)
                    
                    Spacer()
                    
                    // Title (small, next to three dots)
                    Text("Basket")
                        .font(MDXTypography.helveticaNeue(size: 16, weight: .bold))
                        .foregroundColor(MDXColors.textPrimary)
                    
                    Spacer()
                    
                    // More options (top right)
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(MDXColors.textPrimary)
                    }
                }
                .padding(.horizontal, MDXSpacing.md)
                .padding(.vertical, MDXSpacing.sm)
                .background(MDXColors.primaryLight)
                .transition(.move(edge: .top).combined(with: .opacity))
            } else {
                // Full header (default)
                // Toggle Button and Menu (top row)
                HStack {
                    HStack(spacing: 0) {
                        // In-store button
                        Button(action: {
                            isOnline = false
                        }) {
                            Text("In-store")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(isOnline ? MDXColors.textPrimary : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(isOnline ? Color.clear : MDXColors.primary)
                        }
                        
                        // Online button
                        Button(action: {
                            isOnline = true
                        }) {
                            Text("Online")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(isOnline ? .white : MDXColors.textPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(isOnline ? MDXColors.primary : Color.clear)
                        }
                    }
                    .background(MDXColors.primaryLight)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(MDXColors.primary, lineWidth: 1.5)
                    )
                    .frame(width: 140)
                    
                    Spacer()
                    
                    // More options (top right)
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(MDXColors.textPrimary)
                    }
                }
                .padding(.horizontal, MDXSpacing.md)
                .padding(.top, MDXSpacing.md)
                .padding(.bottom, MDXSpacing.sm)
                .background(MDXColors.primaryLight)
                
                // Title and Dropdown (bottom row)
                HStack(alignment: .center, spacing: MDXSpacing.md) {
                    // Title - MDX Typography
                    Text("Basket")
                        .font(MDXTypography.heading1)
                        .foregroundColor(MDXColors.textPrimary)
                    
                    Spacer()
                    
                    // Period Selector - MDX Quaternary style (right-aligned)
                    Button(action: {}) {
                        HStack(spacing: MDXSpacing.sm) {
                            Text(selectedPeriod)
                                .font(MDXTypography.bodyMedium)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(MDXColors.textPrimary)
                        .padding(.horizontal, MDXSpacing.md)
                        .padding(.vertical, MDXSpacing.sm)
                        .background(MDXColors.surface)
                        .cornerRadius(MDXCornerRadius.pill)
                    }
                }
                .padding(.horizontal, MDXSpacing.md)
                .padding(.bottom, MDXSpacing.md)
                .background(MDXColors.primaryLight)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3), value: isCompact)
    }
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct EmptyBasketIllustration: View {
    var body: some View {
        ZStack {
            // Shopping list in center
            VStack(spacing: 0) {
                // Torn top edge
                Path { path in
                    let width: CGFloat = 200
                    let height: CGFloat = 20
                    path.move(to: CGPoint(x: 0, y: height))
                    path.addLine(to: CGPoint(x: width * 0.2, y: height))
                    path.addQuadCurve(to: CGPoint(x: width * 0.3, y: 0), control: CGPoint(x: width * 0.25, y: height * 0.5))
                    path.addQuadCurve(to: CGPoint(x: width * 0.4, y: height), control: CGPoint(x: width * 0.35, y: height * 0.5))
                    path.addLine(to: CGPoint(x: width * 0.6, y: height))
                    path.addQuadCurve(to: CGPoint(x: width * 0.7, y: 0), control: CGPoint(x: width * 0.65, y: height * 0.5))
                    path.addQuadCurve(to: CGPoint(x: width * 0.8, y: height), control: CGPoint(x: width * 0.75, y: height * 0.5))
                    path.addLine(to: CGPoint(x: width, y: height))
                }
                .fill(Color.blue.opacity(0.2))
                .frame(width: 200, height: 20)
                
                // List body
                VStack(spacing: 12) {
                    ForEach(0..<4) { index in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 8)
                                .cornerRadius(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Button on list
                    HStack {
                        Image(systemName: "basket.fill")
                            .foregroundColor(.white)
                        Text("Add")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(MDXColors.primary)
                    .cornerRadius(MDXCornerRadius.large)
                    .padding(.top, 8)
                }
                .padding(20)
                .background(Color.blue.opacity(0.15))
                .cornerRadius(12)
            }
            .frame(width: 200, height: 280)
            
            // Person on left
            PersonView(
                position: .left,
                hairColor: .brown,
                topColor: .yellow,
                pantsColor: .purple,
                basketColor: .orange
            )
            .offset(x: -80, y: 20)
            
            // Person on right
            PersonView(
                position: .right,
                hairColor: .black,
                topColor: .blue,
                pantsColor: .brown,
                hasPhone: true
            )
            .offset(x: 80, y: 40)
        }
        .frame(height: 300)
    }
}

struct PersonView: View {
    enum Position {
        case left, right
    }
    
    let position: Position
    let hairColor: Color
    let topColor: Color
    let pantsColor: Color
    var basketColor: Color? = nil
    var hasPhone: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Head
            Circle()
                .fill(Color(white: 0.95))
                .frame(width: 40, height: 40)
                .overlay(
                    // Hair
                    Ellipse()
                        .fill(hairColor)
                        .frame(width: 45, height: 30)
                        .offset(y: -5)
                )
            
            // Body
            VStack(spacing: 0) {
                // Top
                RoundedRectangle(cornerRadius: 8)
                    .fill(topColor.opacity(0.7))
                    .frame(width: 50, height: 40)
                
                // Pants
                RoundedRectangle(cornerRadius: 4)
                    .fill(pantsColor.opacity(0.7))
                    .frame(width: 45, height: 50)
            }
            
            // Basket (if left person)
            if let basketColor = basketColor {
                Image(systemName: "basket.fill")
                    .foregroundColor(basketColor)
                    .font(.system(size: 24))
                    .offset(x: position == .left ? 30 : -30, y: -20)
            }
            
            // Phone (if right person)
            if hasPhone {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.black)
                    .frame(width: 20, height: 30)
                    .offset(x: position == .right ? 25 : -25, y: -30)
            }
        }
    }
}

struct AddProductView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var selectedProduct: String? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Section
                VStack(spacing: MDXSpacing.md) {
                    MDXSearchFieldWithLabel(
                        text: $searchText,
                        label: "Search products",
                        placeholder: "Enter product name..."
                    )
                    .padding(.horizontal, MDXSpacing.xl)
                    .padding(.top, MDXSpacing.lg)
                    
                    // Search results or empty state
                    if searchText.isEmpty {
                        VStack(spacing: MDXSpacing.md) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(MDXColors.textSecondary.opacity(0.5))
                                .padding(.top, MDXSpacing.xxl)
                            
                            Text("Start typing to search for products")
                                .font(MDXTypography.body)
                                .foregroundColor(MDXColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Search results list
                        ScrollView {
                            LazyVStack(spacing: MDXSpacing.sm) {
                                // Example search results
                                ForEach(mockSearchResults.filter { 
                                    $0.localizedCaseInsensitiveContains(searchText) 
                                }, id: \.self) { product in
                                    ProductSearchResultRow(
                                        productName: product,
                                        isSelected: selectedProduct == product,
                                        onTap: {
                                            selectedProduct = product
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, MDXSpacing.xl)
                            .padding(.top, MDXSpacing.md)
                        }
                    }
                }
                
                Spacer()
                
                // MDX Button Group - Stacked on mobile per MDX guidelines
                VStack(spacing: MDXSpacing.md) {
                    MDXButton.mobile(
                        "Add to basket",
                        icon: Image(systemName: "plus"),
                        type: .primary,
                        isDisabled: selectedProduct == nil,
                        action: {
                            // Add product logic here
                            dismiss()
                        }
                    )
                    
                    MDXButton.mobile(
                        "Cancel",
                        type: .secondary,
                        action: {
                            dismiss()
                        }
                    )
                }
                .padding(.horizontal, MDXSpacing.xl)
                .padding(.bottom, MDXSpacing.lg)
            }
            .background(MDXColors.background)
            .navigationTitle("Add product")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Mock search results for demonstration
    private var mockSearchResults: [String] {
        [
            "Bananas",
            "Apples",
            "Milk",
            "Bread",
            "Eggs",
            "Chicken",
            "Tomatoes",
            "Potatoes",
            "Onions",
            "Carrots",
            "Yogurt",
            "Cheese",
            "Butter",
            "Orange Juice",
            "Coffee"
        ]
    }
}

// MARK: - Product Search Result Row
struct ProductSearchResultRow: View {
    let productName: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: MDXSpacing.md) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? MDXColors.primary : MDXColors.textSecondary)
                    .font(.system(size: 20))
                
                Text(productName)
                    .font(MDXTypography.body)
                    .foregroundColor(MDXColors.textPrimary)
                
                Spacer()
            }
            .padding(.vertical, MDXSpacing.md)
            .padding(.horizontal, MDXSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: MDXCornerRadius.small)
                    .fill(isSelected ? MDXColors.primaryLight : MDXColors.surface)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Basket Item Model
struct BasketItem: Identifiable {
    let id = UUID()
    let name: String
    let quantity: Int
    let price: Double
}

// MARK: - Added Product Row (for last added item display)
struct AddedProductRow: View {
    let product: Product
    let quantity: Int
    let alwaysShowControls: Bool // Whether to always show controls (for search mode)
    let onQuantityChange: (Int) -> Void // Moved after alwaysShowControls
    
    @State private var isExpanded = false // Track if counter is expanded
    @State private var collapseTimer: Timer?
    
    // Helper to extract weight from product information
    private func extractWeight(from info: String?) -> String {
        guard let info = info else { return "" }
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
    
    // Calculate total price and weight based on quantity
    private var totalPrice: Double {
        product.price * Double(quantity)
    }
    
    private var totalWeight: String {
        let weight = extractWeight(from: product.productInformation)
        if weight.isEmpty { return "" }
        
        // Extract number and unit
        if let numberRange = weight.range(of: "\\d+", options: .regularExpression),
           let number = Int(weight[numberRange]) {
            let unit = weight.replacingOccurrences(of: "\\d+\\s*", with: "", options: .regularExpression)
            let totalNumber = number * quantity
            return "\(totalNumber)\(unit)"
        }
        return weight
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
    
    // Start timer to collapse counter after 3 seconds
    private func startCollapseTimer() {
        collapseTimer?.invalidate()
        collapseTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                isExpanded = false
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Product Image (left)
            RoundedRectangle(cornerRadius: 8)
                .fill(MDXColors.surface)
                .frame(width: 80, height: 60)
                .overlay(
                    Image(systemName: getProductIcon(for: product.name))
                        .font(.system(size: 24))
                        .foregroundColor(MDXColors.textSecondary.opacity(0.4))
                )
            
            // Product Info (center)
            VStack(alignment: .leading, spacing: 4) {
                // Product Name (smaller)
                Text(product.name)
                    .font(MDXTypography.bodySmall) // Made smaller
                    .foregroundColor(MDXColors.textPrimary)
                    .lineLimit(1)
                
                // Static Price and Unit: "1.50 (150g)" - NEVER changes with quantity
                let weight = extractWeight(from: product.productInformation)
                Text(String(format: "%.2f (\(weight))", product.price))
                    .font(.system(size: 12)) // Made smaller
                    .foregroundColor(MDXColors.textSecondary)
            }
            
            Spacer()
            
            // Right side: Dynamic Price, Unit (changes with quantity)
            VStack(alignment: .trailing, spacing: 2) {
                // Dynamic Price (larger) - multiplies by quantity
                Text(String(format: "%.2f", totalPrice))
                    .font(MDXTypography.productPrice)
                    .foregroundColor(MDXColors.textPrimary)
                
                // Dynamic Unit (below price) - multiplies by quantity
                if !totalWeight.isEmpty {
                    Text(totalWeight)
                        .font(MDXTypography.bodySmall)
                        .foregroundColor(MDXColors.textSecondary)
                }
            }
            
            // Quantity Display/Controls - Collapsed or Expanded
            if alwaysShowControls || isExpanded {
                // Expanded: Full counter with minus, number, plus
                HStack(spacing: 4) {
                    // Minus Button
                    Button(action: {
                        if quantity > 0 {
                            onQuantityChange(quantity - 1)
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            if !alwaysShowControls {
                                startCollapseTimer()
                            }
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(MDXColors.textPrimary)
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Quantity Number (square)
                    Text("\(quantity)")
                        .font(MDXTypography.helveticaNeue(size: 14, weight: .bold))
                        .foregroundColor(MDXColors.textPrimary)
                        .frame(width: 28, height: 28)
                        .background(MDXColors.background)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // Plus Button (square)
                    Button(action: {
                        onQuantityChange(quantity + 1)
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        if !alwaysShowControls {
                            startCollapseTimer()
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(MDXColors.textPrimary)
                            .frame(width: 28, height: 28)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .transition(.scale.combined(with: .opacity))
            } else {
                // Collapsed: Just show quantity number
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded = true
                    }
                    startCollapseTimer()
                }) {
                    Text("\(quantity)")
                        .font(MDXTypography.helveticaNeue(size: 16, weight: .bold))
                        .foregroundColor(MDXColors.textPrimary)
                        .frame(width: 32, height: 32)
                        .background(MDXColors.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(MDXColors.background)
        .onDisappear {
            collapseTimer?.invalidate()
        }
    }
}

// MARK: - Basket Item Row
struct BasketItemRow: View {
    let item: BasketItem
    
    var body: some View {
        HStack(spacing: MDXSpacing.md) {
            // Product icon/placeholder
            Image(systemName: "square.fill")
                .foregroundColor(MDXColors.primary.opacity(0.3))
                .font(.system(size: 40))
                .frame(width: 50, height: 50)
                .background(MDXColors.surface)
                .cornerRadius(MDXCornerRadius.small)
            
            // Product info
            VStack(alignment: .leading, spacing: MDXSpacing.xs) {
                Text(item.name)
                    .font(MDXTypography.bodyMedium)
                    .foregroundColor(MDXColors.textPrimary)
                
                Text("Quantity: \(item.quantity)")
                    .font(MDXTypography.bodySmall)
                    .foregroundColor(MDXColors.textSecondary)
            }
            
            Spacer()
            
            // Price
            Text(String(format: "CHF %.2f", item.price))
                .font(MDXTypography.bodyMedium)
                .foregroundColor(MDXColors.textPrimary)
        }
        .padding(.vertical, MDXSpacing.sm)
        .padding(.horizontal, MDXSpacing.md)
        .background(MDXColors.surface)
        .cornerRadius(MDXCornerRadius.medium)
    }
}

// MARK: - Preview
// MARK: - Preview
struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView()
            .previewDevice("iPhone 14 Pro")
    }
}



