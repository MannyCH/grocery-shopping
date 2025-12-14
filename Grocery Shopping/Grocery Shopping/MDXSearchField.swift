import SwiftUI

// MARK: - MDX Search Component
// Based on MDX Design System search patterns

struct MDXSearchField: View {
    @Binding var text: String
    let placeholder: String
    let onSubmit: (() -> Void)?
    var focused: FocusState<Bool>.Binding?
    
    @FocusState private var internalIsFocused: Bool
    
    init(
        text: Binding<String>,
        placeholder: String = "Search...",
        onSubmit: (() -> Void)? = nil,
        focused: FocusState<Bool>.Binding? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSubmit = onSubmit
        self.focused = focused
    }
    
    private var isFocused: Bool {
        focused?.wrappedValue ?? internalIsFocused
    }
    
    var body: some View {
        HStack(spacing: MDXSpacing.sm) {
            // Search icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(MDXColors.textSecondary)
                .font(.system(size: 16))
            
            // Text field
            Group {
                if let focusedBinding = focused {
                    TextField(placeholder, text: $text)
                        .font(MDXTypography.body)
                        .foregroundColor(MDXColors.textPrimary)
                        .focused(focusedBinding)
                        .submitLabel(.search)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .disableAutocorrection(true)
                        .keyboardType(.webSearch)
                        .textContentType(.none)
                        .onSubmit {
                            onSubmit?()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    TextField(placeholder, text: $text)
                        .font(MDXTypography.body)
                        .foregroundColor(MDXColors.textPrimary)
                        .focused($internalIsFocused)
                        .submitLabel(.search)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .disableAutocorrection(true)
                        .keyboardType(.webSearch)
                        .textContentType(.none)
                        .onSubmit {
                            onSubmit?()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            // Clear button (shown when text is not empty) - X icon
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    // Keep focus so search container stays visible
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(MDXColors.textSecondary)
                        .font(.system(size: 18))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, MDXSpacing.md)
        .padding(.vertical, MDXSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: MDXCornerRadius.medium)
                .fill(MDXColors.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: MDXCornerRadius.medium)
                .stroke(
                    isFocused ? MDXColors.primary : Color.clear,
                    lineWidth: 2
                )
        )
    }
}

// MARK: - Search Field with Label (MDX Pattern)
struct MDXSearchFieldWithLabel: View {
    @Binding var text: String
    let label: String
    let placeholder: String
    let onSubmit: (() -> Void)?
    
    init(
        text: Binding<String>,
        label: String,
        placeholder: String = "Search...",
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: MDXSpacing.sm) {
            // Label
            Text(label)
                .font(MDXTypography.bodyMedium)
                .foregroundColor(MDXColors.textPrimary)
            
            // Search field
            MDXSearchField(text: $text, placeholder: placeholder, onSubmit: onSubmit)
        }
    }
}

// MARK: - Preview
struct MDXSearchField_Previews: PreviewProvider {
    @State static var searchText = ""
    
    static var previews: some View {
        VStack(spacing: MDXSpacing.lg) {
            MDXSearchField(text: $searchText, placeholder: "Search products...")
            
            MDXSearchFieldWithLabel(
                text: $searchText,
                label: "Search",
                placeholder: "Enter product name..."
            )
        }
        .padding()
        .previewDevice("iPhone 14 Pro")
    }
}

