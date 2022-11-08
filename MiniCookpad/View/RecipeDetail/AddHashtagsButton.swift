import SwiftUI

struct AddHashtagsButton: View {
    let item: RecipeDetailItem
    @Binding var addedHashtags: [Hashtag]
    @State private var isAddRecipeHashtagsViewPresented = false

    var body: some View {
        Button(action: {
            // Try: ボタンタップ時にAddRecipeHashtagsViewをモーダル表示する
            isAddRecipeHashtagsViewPresented = true
        }, label: {
            Text("#")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.orange)
        })
        .sheet(isPresented: $isAddRecipeHashtagsViewPresented) {
            NavigationView {
                AddRecipeHashtagsView(item: item, addedHashtags: $addedHashtags)
            }
        }
    }
}

struct AddHashtagsButton_Previews: PreviewProvider {
    static let item = RecipeDetailItem(
        recipe: .init(
            id: 1,
            title: "ホワイトソースのパスタ",
            description: "おもてなし・パーティに最適♪",
            imageUrl: nil,
            user: .init(name: "クックサマーインターン", imageUrl: nil),
            ingredients: [],
            steps: []
        ),
        hashtags: [
            .init(id: 1, name: "パーティー料理"),
            .init(id: 2, name: "パーティーに"),
            .init(id: 3, name: "おもてなし"),
        ]
    )

    static var previews: some View {
        AddHashtagsButton(item: item, addedHashtags: .constant([]))
    }
}
