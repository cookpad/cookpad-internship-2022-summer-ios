import SwiftUI

@MainActor
final class RecipeDetailViewModel: ObservableObject {
    @Published var item: RecipeDetailItem? = nil

    func request(recipeId: Int64) async {
        // async letを使って、2つのAPIリクエストを並列で行う
        // ref: https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html 「Calling Asynchronous Functions in Parallel」
        async let recipeDetailResponse = apiClient.send(request: GetRecipeDetailRequest(recipeId: recipeId))
        async let recipeDetailHashtagsResponse = apiClient.send(request: GetRecipeHashtagsRequest(recipeIds: [recipeId]))
        do {
            // レスポンスをRecipeDetailItemにまとめる
            item = RecipeDetailItem(
                recipe: try await recipeDetailResponse.recipe,
                hashtags: try await recipeDetailHashtagsResponse.recipeHashtags.first?.hashtags ?? []
            )
        } catch {
            print(error)
        }
    }
}
