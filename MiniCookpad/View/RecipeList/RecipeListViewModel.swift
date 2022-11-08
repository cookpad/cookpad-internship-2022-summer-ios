import SwiftUI

@MainActor
final class RecipeListViewModel: ObservableObject {
    struct DataState {
        var items: [RecipeListItem] = []
        var isFetching: Bool = false // データ取得中かどうか
        var pageInfo: GetRecipeListResponse.PageInfo? = nil

        var didReachLast: Bool {
            pageInfo?.hasNextPage == false
        }
    }

    enum RequestKind {
        case refresh // 初回ロード（または再ロード）
        case loadMore // 追加ロード
    }

    @Published var data: DataState = .init()

    func request(_ kind: RequestKind) async {
        // データ取得中に呼ばれたら何もしない
        if data.isFetching { return }

        // GetRecipeListRequestの引数に渡すpageInfo
        let pageInfo: GetRecipeListResponse.PageInfo?
        switch kind {
        case .refresh:
            // 初回ロード（または再ロード）の時は、GetRecipeListRequestの引数に渡すpageInfoはnilにする
            pageInfo = nil
        case .loadMore:
            // didReachLastがtrueの時は、これ以上取得できるデータはないのでAPIリクエストは送らない
            if data.didReachLast {
                assertionFailure("no more data to fetch")
                return
            }
            // 追加ロードの時は、前回のAPIリクエストで取得したpageInfoをGetRecipeListRequestの引数に渡す
            // GetRecipeListRequestは、クエリパラメータcursorにpageInfo.nextPageCursorの値を指定してAPIリクエストを送る
            pageInfo = data.pageInfo
        }

        // isFetchingをtrueにしてデータ取得中の状態にする
        data = DataState(
            items: data.items,
            isFetching: true,
            pageInfo: pageInfo
        )

        do {
            let recipeListResponse = try await apiClient.send(request: GetRecipeListRequest(pageInfo: pageInfo))
            let recipeHastagsResponse = try await apiClient.send(request: GetRecipeHashtagsRequest(recipeIds: recipeListResponse.recipes.map(\.id)))

            var newItems: [RecipeListItem] = []
            for (recipe, recipeHastags) in zip(recipeListResponse.recipes, recipeHastagsResponse.recipeHashtags) {
                if recipe.id != recipeHastags.recipeId { fatalError("今回は必ずrecipe_idを送った順にレシピに紐付くハッシュタグがAPIから返ってくることが保証されているとして進める") }
                newItems.append(.init(recipe: recipe, hashtags: recipeHastags.hashtags))
            }
            
            let items: [RecipeListItem]
            switch kind {
            case .refresh:
                items = newItems
            case .loadMore:
                // 追加ロードの時は前回までのデータに今回取得したデータを足す
                items = data.items + newItems
            }

            // データの更新
            data = DataState(
                items: items,
                isFetching: false,
                pageInfo: recipeListResponse.pageInfo
            )
        } catch {
            print(error)
        }
    }
}
