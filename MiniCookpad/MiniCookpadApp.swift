import SwiftUI

@main
struct MiniCookpadApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                RecipeListView()
            }
            .navigationViewStyle(.stack) // AutoLayoutのエラーを回避するため
        }
    }
}
