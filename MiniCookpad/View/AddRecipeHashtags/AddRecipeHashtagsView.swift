import SwiftUI

struct AddRecipeHashtagsView: View {
    let item: RecipeDetailItem
    @State private var hashtagsText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                RemoteImage(urlString: item.recipe.imageUrl)
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.smoke, lineWidth: 1))
                    .frame(width: 100, height: 100)

                Text(item.recipe.title)
                    .font(.headline)
                    .foregroundColor(.recipeTitle)

                Text("by \(item.recipe.user.name)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer().frame(height: 24)

            TextField("#タグ1　#タグ2(スペース区切り)", text: $hashtagsText)
                .frame(minWidth: 200)
                .padding(12)
                .background(Color.smoke)
                .cornerRadius(4)

            Spacer().frame(height: 60)

            Button(action: {
                // Try: ハッシュタグを追加するPOSTリクエストを送る
                // Try: POSTリクエストのレスポンスのハッシュタグをRecipeDetailViewに反映する
                // Try: ボタンタップ時にアラートを表示する
            }, label: {
                Text("ハッシュタグを追加する")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(8)
            })
        }
        .frame(maxWidth: 320)
        .offset(y: -100)
        .navigationTitle(Text("ハッシュタグ追加"))
        // Try: アラートを表示して、「OK」を押したらAddRecipeHashtagsViewを閉じる
    }
}

struct AddRecipeHashtagsView_Previews: PreviewProvider {
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
        AddRecipeHashtagsView(item: item)
    }
}
