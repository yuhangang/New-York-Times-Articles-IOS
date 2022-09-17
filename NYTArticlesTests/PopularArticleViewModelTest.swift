import XCTest
import Cuckoo
import Combine
@testable import NYTArticles

class PopularArticleViewModelTest: XCTestCase {
    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var viewModel: PopularArticleViewModel!
    
    var mockArticleStore: MockArticleStore!
    
    //----------------------------------------
    // MARK: - Mock Data
    //----------------------------------------
    
    let mockArticleMostSharedResponse = PopularArticleResponse(resultCount: 10, results: [PopularArticle(id: 1, title: "1. This is a new unit test most shared mock object", publishedDate: "23-12-1995"),
                                                                                   PopularArticle(id: 2, title: "2. This is a new unit test most shared mock object", publishedDate: "23-12-2005"),
                                                                                   PopularArticle(id: 3, title: "3. This is a new unit test most shared mock object", publishedDate: "23-12-2015")])
    
    let mockArticleMostViewedResponse = PopularArticleResponse(resultCount: 10, results: [PopularArticle(id: 1, title: "1. This is a new unit test most viewed mock object", publishedDate: "23-12-1995"),
                                                                                   PopularArticle(id: 2, title: "2. This is a new unit test most viewed mock object", publishedDate: "23-12-2005"),
                                                                                   PopularArticle(id: 3, title: "3. This is a new unit test most viewed mock object", publishedDate: "23-12-2015")])
    
    let mockArticleMostEmailedResponse = PopularArticleResponse(resultCount: 10, results: [PopularArticle(id: 1, title: "1. This is a new unit test most emailed mock object", publishedDate: "23-12-1995"),
                                                                                   PopularArticle(id: 2, title: "2. This is a new unit test most emailed mock object", publishedDate: "23-12-2005"),
                                                                                   PopularArticle(id: 3, title: "3. This is a new unit test most emailed mock object", publishedDate: "23-12-2015")])
    
    let mockJsonArticleMostSharedResponse = """
        {
            "num_results":10,
            "results":[
              {
                 "id":1,
                 "title":"1. This is a new unit test most shared mock object",
                 "published_date":"23-12-1995"
              },
              {
                 "id":2,
                 "title":"2. This is a new unit test most shared mock object",
                 "published_date":"23-12-2005"
              },
              {
                 "id":3,
                 "title":"3. This is a new unit test most shared mock object",
                 "published_date":"23-12-2015"
              }
           ]
        }
    """
    
    let mockJsonArticleMostViewedResponse = """
        {
            "num_results":10,
            "results":[
              {
                 "id":1,
                 "title":"1. This is a new unit test most viewed mock object",
                 "published_date":"23-12-1995"
              },
              {
                 "id":2,
                 "title":"2. This is a new unit test most viewed mock object",
                 "published_date":"23-12-2005"
              },
              {
                 "id":3,
                 "title":"3. This is a new unit test most viewed mock object",
                 "published_date":"23-12-2015"
              }
           ]
        }
    """
    
    let mockJsonArticleMostEmailedResponse = """
        {
            "num_results":10,
            "results":[
              {
                 "id":1,
                 "title":"1. This is a new unit test most emailed mock object",
                 "published_date":"23-12-1995"
              },
              {
                 "id":2,
                 "title":"2. This is a new unit test most emailed mock object",
                 "published_date":"23-12-2005"
              },
              {
                 "id":3,
                 "title":"3. This is a new unit test most emailed mock object",
                 "published_date":"23-12-2015"
              }
           ]
        }
    """

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------
    
    override func setUp() {
        mockArticleStore = MockArticleStore(networkRequestManager: NetworkRequestManager())
        setupMock()

        viewModel = PopularArticleViewModel(articleStore: mockArticleStore,
                                                  searchType: SearchType.mostShared)
    }
    
    func setupMock() {
        Cuckoo.stub(mockArticleStore) { stub in
            when(stub.fetchPopularArticles(searchType: SearchType.mostShared)).thenReturn(Result.Publisher(.success(mockArticleMostSharedResponse.results))
                                                                                                .eraseToAnyPublisher())

            when(stub.fetchPopularArticles(searchType: SearchType.mostViewed)).thenReturn(Result.Publisher(.success(mockArticleMostViewedResponse.results))
                                                                                                .eraseToAnyPublisher())
            
            when(stub.fetchPopularArticles(searchType: SearchType.mostEmailed)).thenReturn(Result.Publisher(.success(mockArticleMostEmailedResponse.results))
                                                                                                .eraseToAnyPublisher())
        }
    }
    
    //----------------------------------------
    // MARK: - Functions
    //----------------------------------------
    
    func updateViewModelSearchType(with searchType: SearchType) {
        viewModel = PopularArticleViewModel(articleStore: mockArticleStore,
                                                  searchType: searchType)
    }
    
    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------
    
    func testMostSharedArticles() {
        // Does not call updateViewModelSearchType as initial value is mostShared in setUp function
        // above
        verify(mockArticleStore).fetchPopularArticles(searchType: SearchType.mostShared)
    }
    
    func testMostViewedArticles() {
        updateViewModelSearchType(with: .mostViewed)
        
        verify(mockArticleStore).fetchPopularArticles(searchType: SearchType.mostViewed)
    }
    
    func testMostEmailedArticles() {
        updateViewModelSearchType(with: .mostEmailed)
        verify(mockArticleStore).fetchPopularArticles(searchType: SearchType.mostEmailed)
    }
    
    func testMostSharedArticlesJSONDecoding() throws {
        let mockJsonData = mockJsonArticleMostSharedResponse.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        XCTAssertNoThrow(try decoder.decode(PopularArticleResponse.self, from: mockJsonData))
    }
    
    func testMostViewedArticlesJSONDecoding() throws {
        let mockJsonData = mockJsonArticleMostViewedResponse.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        XCTAssertNoThrow(try decoder.decode(PopularArticleResponse.self, from: mockJsonData))
    }
    
    func testMostEmailedArticlesJSONDecoding() throws {
        let mockJsonData = mockJsonArticleMostEmailedResponse.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        XCTAssertNoThrow(try decoder.decode(PopularArticleResponse.self, from: mockJsonData))
    }
}

//----------------------------------------
// MARK: - SearchType Matchable
//----------------------------------------

extension SearchType: Matchable {
    public var matcher: ParameterMatcher<SearchType> {
        return ParameterMatcher {
            return $0 == self
        }
    }
}
