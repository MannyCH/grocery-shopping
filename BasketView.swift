import SwiftUI

struct BasketView: View {
    @State private var selectedPeriod = "Weekly"
    @State private var showAddProduct = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Header
                CustomHeaderView()
                
                // Period Selector
                HStack {
                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Text(selectedPeriod)
                                .font(.system(size: 16, weight: .medium))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 12)
                    
                    Spacer()
                }
                
                Divider()
                    .padding(.top, 12)
                
                // Empty State Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Illustration
                        EmptyBasketIllustration()
                            .padding(.top, 40)
                        
                        // Text Content
                        VStack(spacing: 12) {
                            Text("Fill your basket")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("Add products while browsing or directly with the \"+\" below.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                            
                            Text("Switch to the shopping list at any time to use it to shop.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .padding(.top, 32)
                        
                        // Add Product Button
                        Button(action: {
                            showAddProduct = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Add product")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.black)
                            .cornerRadius(30)
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 32)
                        .padding(.bottom, 40)
                    }
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddProduct) {
                AddProductView()
            }
        }
    }
}

struct CustomHeaderView: View {
    @State private var selectedDelivery = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Status bar area (simulated)
            HStack {
                Text("20:27")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "signal.bars.3")
                    Image(systemName: "wifi")
                    Image(systemName: "battery.75")
                    Text("72")
                }
                .font(.system(size: 12))
            }
            .foregroundColor(.black)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .background(Color.orange.opacity(0.1))
            
            // Header content
            HStack(alignment: .bottom, spacing: 16) {
                // Store icon
                Button(action: {
                    selectedDelivery = false
                }) {
                    Image(systemName: "building.2")
                        .font(.system(size: 20))
                        .foregroundColor(selectedDelivery ? .gray : .white)
                        .frame(width: 40, height: 40)
                        .background(selectedDelivery ? Color.orange.opacity(0.1) : Color.orange)
                        .clipShape(Circle())
                }
                
                // Delivery icon
                Button(action: {
                    selectedDelivery = true
                }) {
                    Image(systemName: "truck.box")
                        .font(.system(size: 20))
                        .foregroundColor(selectedDelivery ? .white : .orange)
                        .frame(width: 40, height: 40)
                        .background(selectedDelivery ? Color.orange : Color.orange.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                // Title
                Text("Basket")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                // More options
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            .background(Color.orange.opacity(0.1))
        }
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
                    .background(Color.orange)
                    .cornerRadius(20)
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
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add Product")
                    .font(.largeTitle)
                    .padding()
                
                // Add your product input form here
                
                Spacer()
            }
            .navigationTitle("Add Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Preview
struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView()
            .previewDevice("iPhone 14 Pro")
    }
}

