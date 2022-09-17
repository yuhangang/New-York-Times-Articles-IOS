import Foundation
import Combine

class PopularArticleViewModel: StatefulViewModel<[PopularArticle]> {
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(articleStore: ArticleStore, searchType: SearchType) {
        self.articleStore = articleStore
        self.searchType = searchType
    }
    
    //----------------------------------------
    // MARK: - Popular Article API Call
    //----------------------------------------
    
    override func load() -> AnyPublisher<[PopularArticle], Error> {
        return fetchPopularArticles()
    }
    
    func fetchPopularArticles() -> AnyPublisher<[PopularArticle], Error> {
        return articleStore.fetchPopularArticles(searchType: searchType)
    }
        
    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------
                    
    let searchType: SearchType
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let articleStore: ArticleStore
}
