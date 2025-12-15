import SwiftUI

// MARK: - Shopping List View (In-Store Mode)
struct ShoppingListView: View {
    @State private var selectedPeriod = "Weekly"
    @State private var newItemText = ""
    @State private var planningItems: [ShoppingListItem] = []
    @State private var doneItems: [ShoppingListItem] = []
    @FocusState private var isAddingItem: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ShoppingListHeader(selectedPeriod: $selectedPeriod)
            
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
        let newItem = ShoppingListItem(name: newItemText)
        planningItems.append(newItem)
        newItemText = ""
        isAddingItem = false
    }
    
    private func toggleItem(_ item: ShoppingListItem) {
        if let index = planningItems.firstIndex(where: { $0.id == item.id }) {
            planningItems.remove(at: index)
            doneItems.append(item)
        } else if let index = doneItems.firstIndex(where: { $0.id == item.id }) {
            doneItems.remove(at: index)
            planningItems.append(item)
        }
    }
}

// MARK: - Shopping List Header
struct ShoppingListHeader: View {
    @Binding var selectedPeriod: String
    @State private var isOnline = false // In-store by default
    
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
            
            Spacer()
            
            // Find product button
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
            
            // Radio button (unchecked)
            Button(action: onToggle) {
                Image(systemName: "circle")
                    .font(.system(size: 24))
                    .foregroundColor(MDXColors.textPrimary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, MDXSpacing.md)
        .padding(.vertical, MDXSpacing.md)
        .background(MDXColors.background)
    }
}

// MARK: - Preview
struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
            .previewDevice("iPhone 14 Pro")
    }
}

