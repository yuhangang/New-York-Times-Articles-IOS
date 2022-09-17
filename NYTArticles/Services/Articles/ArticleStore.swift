import Foundation
import Combine

class ArticleStore: NSObject {
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(networkRequestManager: NetworkRequestManager) {
        self.networkRequestManager = networkRequestManager
        
        super.init()
    }
    
    //----------------------------------------
    // MARK: - Fetch articles
    //----------------------------------------
    
    func searchArticles(keyword: String) -> AnyPublisher<[SearchArticle], Error> {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "q", value: keyword))
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let publisher = networkRequestManager.authorizedApiRequest(.get, "search/v2/articlesearch.json", queryItems: queryItems)
            .decode(type: SearchArticleResponse.self, decoder: decoder)
            .map({ (result: SearchArticleResponse) -> [SearchArticle] in
                return result.response.results
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    func fetchPopularArticles(searchType: SearchType) -> AnyPublisher<[PopularArticle], Error> {
        var path: String?
        
        switch searchType {
        case .mostEmailed:
            path = "mostpopular/v2/emailed/1.json"
            
        case .mostShared:
            path = "mostpopular/v2/shared/1/facebook.json"

        case .mostViewed:
            path = "mostpopular/v2/viewed/7.json"
            
        default: break
        }
        
        let decoder = JSONDecoder()
        let publisher = networkRequestManager.authorizedApiRequest(.get, path ?? "")
            .decode(type: PopularArticleResponse.self, decoder: decoder)
            .map({ (result: PopularArticleResponse) -> [PopularArticle] in
                return result.results
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let networkRequestManager: NetworkRequestManager
}
