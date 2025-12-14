import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 3 // Basket is the 4th tab (index 3)
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            OffersView()
                .tabItem {
                    Image(systemName: "percent")
                    Text("Offers")
                }
                .tag(1)
            
            CumulusView()
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Cumulus")
                }
                .tag(2)
            
            BasketView()
                .tabItem {
                    Image(systemName: "basket.fill")
                    Text("Basket")
                }
                .tag(3)
            
            SubitoGoView()
                .tabItem {
                    Image(systemName: "bolt.fill")
                    Text("subitoGo")
                }
                .tag(4)
        }
        .accentColor(.orange)
    }
}

// Placeholder views for other tabs
struct HomeView: View {
    var body: some View {
        Text("Home")
            .font(.largeTitle)
    }
}

struct OffersView: View {
    var body: some View {
        Text("Offers")
            .font(.largeTitle)
    }
}

struct CumulusView: View {
    var body: some View {
        Text("Cumulus")
            .font(.largeTitle)
    }
}

struct SubitoGoView: View {
    var body: some View {
        Text("subitoGo")
            .font(.largeTitle)
    }
}

