import Foundation

struct GetRecipeDetailRequest: APIRequest {
    typealias Response = GetRecipeDetailResponse
    let recipeId: Int64
    let method: HTTPMethod = .get

    var url: URL {
        .init(string: "http://localhost:3001/recipes/\(recipeId)")!
    }
}

struct GetRecipeDetailResponse: Decodable {
    struct Recipe: Decodable {
        struct User: Decodable {
            let name: String
            let imageUrl: String?
        }

        struct Ingredient: Decodable, Identifiable {
            let id: Int64
            let name: String
            let quantity: String?
        }

        struct Step: Decodable, Identifiable {
            let id: Int64
            let memo: String
            let imageUrl: String?
        }

        let id: Int64
        let title: String
        let description: String
        let imageUrl: String?
        let user: User
        let ingredients: [Ingredient]
        let steps: [Step]
    }

    let recipe: Recipe
}
