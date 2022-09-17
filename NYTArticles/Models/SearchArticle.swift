import Foundation

struct SearchArticleResponse: Codable {
    let response: SearchArticleResults
}

struct SearchArticleResults: Codable {
    let results: [SearchArticle]
    
    enum CodingKeys: String, CodingKey {
        case results = "docs"
    }
}

struct SearchArticle: Codable, Hashable {
    let id: String
    let publishedDate: Date
    let headline: ArticleHeadline?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case publishedDate = "pub_date"
        case headline
    }
    
    //----------------------------------------
    // MARK: - Hashable protocols
    //----------------------------------------
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: SearchArticle, rhs: SearchArticle) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ArticleHeadline: Codable {
    let printHeadline: String?
    
    enum CodingKeys: String, CodingKey {
        case printHeadline = "print_headline"
    }
}
