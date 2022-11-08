import Foundation

struct PostRecipeHashtagsRequest: APIRequest {
    typealias Response = PostRecipeListResponse
    let url = URL(string: "http://localhost:3002/hashtags")!
    let method: HTTPMethod = .post
    // リクエストに必要なデータをpropertyで受け取る
    let recipeId: Int64
    let hashtagsText:String

    // bodyにrecipe_idとvalueを追加する
    var body: [String : Any] {
        [
            "recipe_id": recipeId,
            "value": hashtagsText,
        ]
    }
}

struct PostRecipeListResponse: Decodable {
    let hashtags: [Hashtag]
}
