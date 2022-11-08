import SwiftUI

struct RecipeListView: View {
    @State private var items: [RecipeListItem] = []

    var body: some View {
        List(items) { item in
            NavigationLink(destination: Text("レシピ詳細 id:\(item.recipe.id)")) {
                RecipeListRow(item: item)
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                items = RecipeListSampleDataProvider.makeRecipeListSampleData()
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
