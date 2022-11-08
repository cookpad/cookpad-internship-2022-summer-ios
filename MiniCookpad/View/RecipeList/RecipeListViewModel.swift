import SwiftUI

@MainActor
final class RecipeListViewModel: ObservableObject {
    @Published var items: [RecipeListItem] = []

    func request() async {
        do {
            let recipeListResponse = try await apiClient.send(request: GetRecipeListRequest(pageInfo: nil))
            let recipeHastagsResponse = try await apiClient.send(request: GetRecipeHashtagsRequest(recipeIds: recipeListResponse.recipes.map(\.id)))

            var newItems: [RecipeListItem] = []
            for (recipe, recipeHastags) in zip(recipeListResponse.recipes, recipeHastagsResponse.recipeHashtags) {
                if recipe.id != recipeHastags.recipeId { fatalError("今回は必ずrecipe_idを送った順にレシピに紐付くハッシュタグがAPIから返ってくることが保証されているとして進める") }
                newItems.append(.init(recipe: recipe, hashtags: recipeHastags.hashtags))
            }
            
            items = newItems
        } catch {
            print(error)
        }
    }
}
