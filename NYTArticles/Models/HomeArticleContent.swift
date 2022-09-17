import Foundation

struct HomeArticleContent: Codable, Hashable {
    let search: [SearchType]
    let popular: [SearchType]
}
