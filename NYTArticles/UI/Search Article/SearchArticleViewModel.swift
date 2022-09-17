import Foundation
import Combine

final class SearchArticleViewModel: StatefulViewModel<[SearchArticle]> {
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(articleStore: ArticleStore) {
        self.articleStore = articleStore
    }
    
    //----------------------------------------
    // MARK: - Data loading
    //----------------------------------------
    
    override func load() -> AnyPublisher<[SearchArticle], Error> {
        return searchArticles()
    }
    
    func searchArticles() -> AnyPublisher<[SearchArticle], Error> {
        guard let searchKeyword = searchKeyword else {
            return Result.Publisher(.success([]))
                .eraseToAnyPublisher()
        }
        
        return articleStore.searchArticles(keyword: searchKeyword)
            .eraseToAnyPublisher()
    }
    
    //----------------------------------------
    // MARK: - Update search keyword
    //----------------------------------------
    
    func updateSearchKeyword(_ keyword: String?) {
        self.searchKeyword = keyword
        
        self.reloadManually()
    }
    
    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------
        
    private(set) var searchKeyword: String?
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
                
    private let articleStore: ArticleStore
}
