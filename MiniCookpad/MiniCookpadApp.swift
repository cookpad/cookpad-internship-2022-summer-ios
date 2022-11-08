import SwiftUI

// 今回の講義では簡略化のためAPIクライアントをグローバル変数で定義する
let apiClient: APIClient = {
    if ProcessInfo.processInfo.isRunningForPreview || ProcessInfo.processInfo.useStubAPIClient {
        return StubAPIClient()
    } else {
        return MiniCookpadAPIClient()
    }
}()

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
