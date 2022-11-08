import SwiftUI

struct RecipeListRow: View {
    let item: RecipeListItem
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            RemoteImage(urlString: item.recipe.imageUrl)
                .frame(width: 100, height: 100)
                .cornerRadius(4)
            VStack(alignment: .leading, spacing: 6) {
                Text(item.recipe.title)
                    .font(.headline)
                    .foregroundColor(.recipeTitle)
                Text("by \(item.recipe.user.name)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(item.recipe.ingredients.map(\.name).joined(separator: ", "))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Text(item.hashtags.map({ "#\($0.name)" }).joined(separator: " "))
                    .font(.caption2)
                    .foregroundColor(.black)
                    .lineLimit(1)
            }
        }
    }
}

struct RecipeListRow_Previews: PreviewProvider {
    static let item = RecipeListItem(
        recipe: .init(
            id: 1,
            title: "ホワイトソースのパスタ",
            description: "おもてなし・パーティに最適♪",
            imageUrl: nil,
            user: .init(name: "クックサマーインターン"),
            ingredients: ["芽キャベツ", "生ハム", "ホワイトソース", "パスタ", "塩"].map(GetRecipeListResponse.Recipe.Ingredient.init)
        ),
        hashtags: [
            .init(id: 1, name: "パーティー料理"),
            .init(id: 2, name: "パーティーに"),
            .init(id: 3, name: "おもてなし"),
        ]
    )

    static var previews: some View {
        RecipeListRow(item: item)
    }
}
