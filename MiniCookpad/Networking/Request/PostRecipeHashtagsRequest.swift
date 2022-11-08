import Foundation

struct PostRecipeHashtagsRequest: APIRequest {
    typealias Response = PostRecipeListResponse
    let url = URL(string: "http://localhost:3002/hashtags")!
    let method: HTTPMethod = .post

    // Try: body に recipe_id と value を追加してリクエストを送る
}

struct PostRecipeListResponse: Decodable {
    let hashtags: [Hashtag]
}
