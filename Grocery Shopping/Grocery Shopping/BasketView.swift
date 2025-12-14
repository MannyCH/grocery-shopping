import SwiftUI

struct BasketView: View {
    @State private var selectedPeriod = "Weekly"
    @State private var showAddProduct = false
    @State private var searchText = ""
    @State private var scrollOffset: CGFloat = 0
    private let scrollThreshold: CGFloat = 50 // When to show compact header
    
    // Mock basket items for demonstration
    @State private var basketItems: [BasketItem] = [
        BasketItem(name: "Bananas", quantity: 2, price: 3.50),
        BasketItem(name: "Apples", quantity: 1, price: 2.80),
        BasketItem(name: "Milk", quantity: 1, price: 4.20),
        BasketItem(name: "Bread", quantity: 1, price: 2.50),
        BasketItem(name: "Eggs", quantity: 6, price: 5.90)
    ]
    
    // Sample products for search - Using MDX web component structure
    let sampleProducts: [Product] = [
        // Dairy Products - Multiple Milk Varieties (at least 3+ for "milk" search)
        Product(productId: "104041100001", name: "Semi-skimmed Milk", brand: "Migros", productInformation: "1L für eine Flasche von diesem Produkt", price: 2.80, originalPrice: 3.20, insteadOf: "statt", imageUrl: nil, ratingAverage: 4.5, ratingCount: 12, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: true, discountAmount: "15%", discountDescription: "Sale", cumulusPoints: 5, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: "01", reductionAmount: "5", reductionSuffix: "günstiger"),
        Product(productId: "104041100002", name: "Whole Milk", brand: "Migros", productInformation: "1L für eine Flasche von diesem Produkt", price: 2.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.2, ratingCount: 8, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: "A", hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "New", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100003", name: "Bio Milk", brand: "Migros Bio", productInformation: "1L für eine Flasche von diesem Produkt", price: 3.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.8, ratingCount: 25, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: "A", hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 10, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100004", name: "Lactose-free Milk", brand: "Migros", productInformation: "1L für eine Flasche von diesem Produkt", price: 3.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.3, ratingCount: 15, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100005", name: "Skimmed Milk", brand: "Migros", productInformation: "1L für eine Flasche von diesem Produkt", price: 2.40, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.1, ratingCount: 6, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: "A", hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100006", name: "Chocolate Milk", brand: "Migros", productInformation: "500ml für eine Flasche von diesem Produkt", price: 3.80, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.6, ratingCount: 18, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "New", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100007", name: "Almond Milk", brand: "Migros", productInformation: "1L für eine Flasche von diesem Produkt", price: 4.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.4, ratingCount: 9, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100008", name: "Oat Milk", brand: "Migros Bio", productInformation: "1L für eine Flasche von diesem Produkt", price: 3.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.7, ratingCount: 22, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 8, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100009", name: "Greek Yogurt", brand: "Migros", productInformation: "500g für eine Packung von diesem Produkt", price: 4.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.6, ratingCount: 14, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100010", name: "Swiss Cheese", brand: "Migros", productInformation: "200g für eine Packung von diesem Produkt", price: 8.90, originalPrice: 9.90, insteadOf: "statt", imageUrl: nil, ratingAverage: 4.7, ratingCount: 31, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: true, discountAmount: "10%", discountDescription: "Sale", cumulusPoints: 15, badgeDescription: "Sale", minimumPieces: nil, discountPrice: nil, reductionTypeId: "01", reductionAmount: "5", reductionSuffix: "günstiger"),
        
        // Fruits
        Product(productId: "104041100011", name: "Bananas", brand: nil, productInformation: "1kg für eine Packung von diesem Produkt", price: 3.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.4, ratingCount: 45, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100012", name: "Apples", brand: nil, productInformation: "1kg für eine Packung von diesem Produkt", price: 2.80, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.5, ratingCount: 38, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100013", name: "Strawberries", brand: nil, productInformation: "250g für eine Packung von diesem Produkt", price: 5.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.8, ratingCount: 52, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100014", name: "Oranges", brand: nil, productInformation: "1kg für eine Packung von diesem Produkt", price: 3.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.3, ratingCount: 27, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        
        // Vegetables
        Product(productId: "104041100015", name: "Tomatoes", brand: nil, productInformation: "500g für eine Packung von diesem Produkt", price: 4.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.2, ratingCount: 19, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100016", name: "Carrots", brand: nil, productInformation: "1kg für eine Packung von diesem Produkt", price: 2.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.1, ratingCount: 11, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100017", name: "Lettuce", brand: nil, productInformation: "1 Stück von diesem Produkt", price: 2.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.0, ratingCount: 7, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        
        // Bread & Bakery
        Product(productId: "104041100018", name: "White Bread", brand: "Migros", productInformation: "500g für eine Stange von diesem Produkt", price: 2.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.3, ratingCount: 33, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: nil, badgeDescription: nil, minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100019", name: "Whole Grain Bread", brand: "Migros", productInformation: "500g für eine Stange von diesem Produkt", price: 3.20, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.6, ratingCount: 41, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 6, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        
        // Eggs
        Product(productId: "104041100020", name: "Free Range Eggs", brand: "Migros", productInformation: "6 Stück von diesem Produkt", price: 5.90, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.7, ratingCount: 67, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 12, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil),
        Product(productId: "104041100021", name: "Organic Eggs", brand: "Migros Bio", productInformation: "6 Stück von diesem Produkt", price: 6.50, originalPrice: nil, insteadOf: nil, imageUrl: nil, ratingAverage: 4.9, ratingCount: 89, availability: "available", energyBadgeUrl: nil, energyBadgeAltText: nil, hasDiscount: false, discountAmount: nil, discountDescription: nil, cumulusPoints: 15, badgeDescription: "Bio", minimumPieces: nil, discountPrice: nil, reductionTypeId: nil, reductionAmount: nil, reductionSuffix: nil)
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
        VStack(spacing: 0) {
            // Custom Header (includes toggle, title, and dropdown)
            CustomHeaderView(
                selectedPeriod: $selectedPeriod,
                isCompact: scrollOffset > scrollThreshold
            )
                
                Divider()
                
                // Content Area with scroll detection
                ScrollView {
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)
                    if searchText.isEmpty && basketItems.isEmpty {
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
                    } else if !searchText.isEmpty {
                        // Search Results - Product Cards
                        VStack(spacing: MDXSpacing.md) {
                            // Product cards (filtered by search)
                            if filteredProducts.isEmpty {
                                // No results state
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
                                        
                                        // First product
                                        MDXProductCard(
                                            product: filteredProducts[0],
                                            initialQuantity: basketItems.first(where: { $0.name == filteredProducts[0].name })?.quantity ?? 0,
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
                                                }
                                            }
                                        )
                                        
                                        // "found products" caption after first item
                                        Text("found products")
                                            .font(MDXTypography.bodySmall)
                                            .foregroundColor(MDXColors.textSecondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 16)
                                            .padding(.top, MDXSpacing.md)
                                            .padding(.bottom, MDXSpacing.sm)
                                        
                                        // Remaining products (skip first one)
                                        ForEach(Array(filteredProducts.enumerated()), id: \.element.id) { index, product in
                                            if index > 0 {
                                                MDXProductCard(
                                                    product: product,
                                                    initialQuantity: basketItems.first(where: { $0.name == product.name })?.quantity ?? 0,
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
                                                        }
                                                    }
                                                )
                                            }
                                        }
                                    }
                                }
                                .padding(.top, MDXSpacing.md)
                                .padding(.bottom, MDXSpacing.xl)
                            }
                        }
                    } else {
                        // Basket with items (no search)
                        VStack(spacing: MDXSpacing.md) {
                            // Basket items list
                            LazyVStack(spacing: MDXSpacing.sm) {
                                ForEach(basketItems, id: \.id) { item in
                                    BasketItemRow(item: item)
                                }
                            }
                            .padding(.horizontal, MDXSpacing.xl)
                            .padding(.top, MDXSpacing.lg)
                            .padding(.bottom, MDXSpacing.xl)
                        }
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = -value
                }
                
                // Search Field - MDX Search Component (above bottom navigation)
                MDXSearchField(
                    text: $searchText,
                    placeholder: "add products"
                )
                .padding(.horizontal, MDXSpacing.xl)
                .padding(.vertical, MDXSpacing.md)
                .background(MDXColors.background)
            }
            .background(MDXColors.background)
            .sheet(isPresented: $showAddProduct) {
                AddProductView()
            }
        }
}

struct CustomHeaderView: View {
    @State private var isOnline = true // "online" is active by default
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
struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView()
            .previewDevice("iPhone 14 Pro")
    }
}



