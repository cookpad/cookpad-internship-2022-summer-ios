import SwiftUI

struct RecipeDetailView: View {
    private static let horizontalMargin: CGFloat = 16
    private static let verticalMargin: CGFloat = 16

    @StateObject private var viewModel = RecipeDetailViewModel()
    let recipeId: Int64
    @State private var addedHashtags: [Hashtag] = [] // ハッシュタグ追加画面で追加したハッシュタグを保持する

    var body: some View {
        ScrollView {
            if let item = viewModel.item {
                LazyVStack(alignment: .leading, spacing: 0) {
                    // 画像を正方形（縦横比1:1）でクロップする
                    Color.clear // 表示枠を作る
                        .overlay(
                            RemoteImage(urlString: item.recipe.imageUrl)
                                .scaledToFill() // 画像の縦横比を維持
                        )
                        .aspectRatio(1.0, contentMode: .fit) // 表示枠の縦横比を1:1に指定する
                        .clipped() // 表示枠で切り取る

                    Spacer()
                        .frame(height: Self.verticalMargin)

                    VStack(alignment: .leading, spacing: 16) {
                        // レシピタイトル
                        Text(item.recipe.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.recipeTitle)

                        HStack(alignment: .center, spacing: 4) {
                            // 作者アイコン
                            RemoteImage(urlString: item.recipe.user.imageUrl)
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                .cornerRadius(15) // cornerRadiusは表示領域で切り取った上で角丸を付けるのでclippedは不要
                            // 作者名
                            Text(item.recipe.user.name)
                                .font(.body)
                                .foregroundColor(.gray)
                        }

                        if !(item.hashtags.isEmpty && addedHashtags.isEmpty) { // ハッシュタグが1つもない場合は枠自体を表示しない
                            // ハッシュタグ
                            // addedHashtagsとitem.hashtagsを合わせたものを表示する
                            Text((addedHashtags + item.hashtags).map({ "#\($0.name)" }).joined(separator: "　"))
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .frame(maxWidth: .infinity, alignment: .leading) // maxWidth: .infinity を指定して画面幅いっぱいに広げる
                                .padding(8)
                                .background(Color.smoke) // padding後の領域に対して背景を付ける
                                .cornerRadius(6)
                        }

                        // レシピの説明文
                        Text(item.recipe.description)
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, Self.horizontalMargin)

                    // 材料欄
                    headline("材料") // 複数回使うので関数にした

                    // 背景色を付けるために何番目の要素かを知りたいのでenumerated()を使う
                    // https://developer.apple.com/documentation/swift/array/enumerated()
                    ForEach(Array(item.recipe.ingredients.enumerated()), id: \.element.id) { index, ingredient in
                        HStack(alignment: .center, spacing: 0) {
                            Text(ingredient.name)
                            Spacer()
                            if let quantity = ingredient.quantity {
                                Text(quantity)
                            }
                        }
                        .padding(.horizontal, Self.horizontalMargin)
                        .padding(.vertical, 8)
                        .background(index % 2 == 0 ? Color.ivory : Color.white) // 奇遇によって背景色を変える
                    }

                    // 作り方欄
                    headline("作り方")

                    // ここでも作り方に番号を付ける必要があるためenumerated()を使う
                    ForEach(Array(item.recipe.steps.enumerated()), id: \.element.id) { index, step in
                        HStack(alignment: .top, spacing: 8) {
                            Text(String(index + 1))
                                .font(.caption)
                                .fontWeight(.bold)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .background(Color.gray)
                                .cornerRadius(2)

                            Text(step.memo)

                            if let imageUrl = step.imageUrl { // 作り方の画像があれば表示する
                                Spacer()
                                RemoteImage(urlString: imageUrl)
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .cornerRadius(4)
                            }
                        }
                        .padding(.horizontal, Self.horizontalMargin)
                        .padding(.vertical, 16)

                        Divider()
                            .padding(.leading, Self.horizontalMargin) // 左側だけ16pxの余白を付ける
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline) // navigationBarのタイトルを小さくする
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if let item = viewModel.item {
                    AddHashtagsButton(item: item, addedHashtags: $addedHashtags)
                }
            }
        }
        .task {
            // ViewModelを介してAPIリクエストを行う
            await viewModel.request(recipeId: recipeId)
        }
    }

    private func headline(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .padding(.top, Self.verticalMargin * 2)
            .padding(.bottom, 8)
            .padding(.horizontal, Self.horizontalMargin)
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeDetailView(recipeId: 1)
        }
    }
}
