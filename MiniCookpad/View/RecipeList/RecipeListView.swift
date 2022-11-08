import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @State private var isInitialDataLoaded: Bool = false

    var body: some View {
        List(Array(viewModel.data.items.enumerated()), id: \.element.id) { index, item in
            // レシピ詳細画面に遷移
            NavigationLink(destination: RecipeDetailView(recipeId: item.recipe.id)) {
                RecipeListRow(item: item)
            }

            // リストの最後にAutoLoadingIndicatorを追加する
            if index == viewModel.data.items.count - 1 {
                AutoLoadingIndicator(
                    isFetching: viewModel.data.isFetching,
                    didReachLast: viewModel.data.didReachLast,
                    loadMoreAction: {
                        await viewModel.request(.loadMore)
                    }
                )
            }
        }
        .listStyle(PlainListStyle())
        // Pull-to-refreshでユーザーがデータを再ロードできるようにする
        .refreshable {
            await viewModel.request(.refresh)
        }
        .task {
            // 初回表示の時のみリクエストを送る
            // レシピ詳細画面からレシピ一覧画面に戻ってきた時にもtask Modifierのクロージャは呼ばれるので
            // これがないとレシピ詳細画面から戻ってくる度に追加ロードしたレシピが消えてしまう
            if !isInitialDataLoaded {
                await viewModel.request(.refresh)
                isInitialDataLoaded = true
            }
        }
        .navigationTitle("レシピ一覧")
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeListView()
        }
    }
}
