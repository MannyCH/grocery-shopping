import SwiftUI

@main
struct GroceryShoppingApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}


struct Previews_GroceryShoppingApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
