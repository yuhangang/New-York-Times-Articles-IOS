import Foundation

enum SearchType: String, Codable, Hashable {
    case newSearch
    case mostViewed
    case mostShared
    case mostEmailed
    
    var localizedString: String {
        switch self {
        case .newSearch:
            return NSLocalizedString("search_articles", comment: "text")
            
        case .mostViewed:
            return NSLocalizedString("most_viewed", comment: "text")
            
        case .mostShared:
            return NSLocalizedString("most_shared", comment: "text")
            
        case .mostEmailed:
            return NSLocalizedString("most_emailed", comment: "text")
        }
    }
}
