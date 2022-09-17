import Foundation

struct PopularArticleResponse: Codable, Equatable {
    let resultCount: Int
    let results: [PopularArticle]
    
    enum CodingKeys: String, CodingKey {
        case resultCount = "num_results"
        case results
    }
}

struct PopularArticle: Codable, Hashable {
    let id: Int
    let title: String
    let publishedDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case publishedDate = "published_date"
    }
    
    //----------------------------------------
    // MARK: - Hashable protocols
    //----------------------------------------
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PopularArticle, rhs: PopularArticle) -> Bool {
        return lhs.id == rhs.id
    }
}
