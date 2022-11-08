import Foundation

struct GetRecipeListRequest: APIRequest {
    typealias Response = GetRecipeListResponse
    let pageInfo: GetRecipeListResponse.PageInfo?
    let url = URL(string: "http://localhost:3001/recipes")!
    let method: HTTPMethod = .get
    let limit = 10

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [.init(name: "limit", value: String(limit))]
        if let pageInfo = pageInfo {
            items.append(.init(name: "cursor", value: pageInfo.nextPageCursor))
        }
        return items
    }
}

struct GetRecipeListResponse: Decodable {
    struct Recipe: Decodable {
        struct User: Decodable {
            let name: String
        }

        struct Ingredient: Decodable {
            let name: String
        }

        let id: Int64
        let title: String
        let description: String
        let imageUrl: String?
        let user: User
        let ingredients: [Ingredient]
    }

    struct PageInfo: Decodable {
        let nextPageCursor: String
        let hasNextPage: Bool
    }

    let recipes: [Recipe]
    let pageInfo: PageInfo
}
