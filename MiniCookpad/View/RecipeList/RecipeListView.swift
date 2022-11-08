import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()

    var body: some View {
        List(viewModel.items) { item in
            NavigationLink(destination: Text("レシピ詳細 id:\(item.recipe.id)")) {
                RecipeListRow(item: item)
            }
        }
        .listStyle(PlainListStyle())
        .task {
            await viewModel.request()
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
