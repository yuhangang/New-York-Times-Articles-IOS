import XCTest
import Cuckoo
import Combine
@testable import NYTArticles

class searchArticleViewModelTest: XCTestCase {
    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------
    
    var viewModel: SearchArticleViewModel!
    
    var mockArticleStore: MockArticleStore!
    
    var cancellables = Set<AnyCancellable>()
    
    //----------------------------------------
    // MARK: - Mock Data
    //----------------------------------------
        
    let mockSearchArticleResponseJoe = SearchArticleResponse(response: SearchArticleResults(results: [SearchArticle(id: "1", publishedDate: NYTDateFormatter.dateFromString(string: "2021-07-27 13:18:59 +utc")!, headline: ArticleHeadline(printHeadline: "1. Unit test mock object for Joe.")),
                                                                                                SearchArticle(id: "2", publishedDate: NYTDateFormatter.dateFromString(string: "2021-07-27 13:18:59 +utc")!, headline: ArticleHeadline(printHeadline: "2. Unit test mock object for Joe.")),
                                                                                                SearchArticle(id: "3", publishedDate: NYTDateFormatter.dateFromString(string: "2021-07-27 13:18:59 +utc")!, headline: ArticleHeadline(printHeadline: "3. Unit test mock object for Joe."))]))
    
    let mockSearchArticleResponseJohnson = SearchArticleResponse(response: SearchArticleResults(results: [SearchArticle(id: "1", publishedDate: NYTDateFormatter.dateFromString(string: "2021-07-27 13:18:59 +utc")!, headline: ArticleHeadline(printHeadline: "1. Unit test mock object for Johnson.")),
                                                                                                SearchArticle(id: "2", publishedDate: NYTDateFormatter.dateFromString(string: "2021-07-27 13:18:59 +utc")!, headline: ArticleHeadline(printHeadline: "2. Unit test mock object for Johnson.")),
                                                                                                SearchArticle(id: "3", publishedDate: NYTDateFormatter.dateFromString(string: "2021-07-27 13:18:59 +utc")!, headline: ArticleHeadline(printHeadline: "3. Unit test mock object for Johnson."))]))
    
    let mockJsonSearchArticleResponse = """
        {
           "response":{
              "docs":[
                 {
                    "_id":"1",
                    "pub_date":"2021-05-24T21:35:22+0000",
                    "headline":{
                       "print_headline":"This is a new unit test mock object."
                    }
                 },
                 {
                    "_id":"2",
                    "pub_date":"2021-05-24T21:35:22+0000",
                    "headline":{
                       "print_headline":"This is a new unit test mock object."
                    }
                 },
                 {
                    "_id":"3",
                    "pub_date":"2021-05-24T21:35:22+0000",
                    "headline":{
                       "print_headline":"This is a new unit test mock object."
                    }
                 }
              ]
           }
        }
    """

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------
    
    override func setUp() {
        mockArticleStore = MockArticleStore(networkRequestManager: NetworkRequestManager())
        viewModel = SearchArticleViewModel(articleStore: mockArticleStore)
        
        setupMock()
    }
    
    override func tearDown() {
        cancellables.removeAll()
    }
    
    func setupMock() {
        Cuckoo.stub(mockArticleStore) { stub in
            when(stub.searchArticles(keyword: "Johnson")).thenReturn(Result.Publisher(.success(mockSearchArticleResponseJohnson.response.results))
                                                                    .eraseToAnyPublisher())
            when(stub.searchArticles(keyword: "Joe")).thenReturn(Result.Publisher(.success(mockSearchArticleResponseJoe.response.results))
                                                                    .eraseToAnyPublisher())
            
            when(stub.searchArticles(keyword: "J")).thenReturn(Result.Publisher(.success(mockSearchArticleResponseJoe.response.results))
                                                                    .eraseToAnyPublisher())
            
            when(stub.searchArticles(keyword: "JoeRequestFail")).thenReturn(Result.Publisher(.failure(AppError.badRequest))
                                                                    .eraseToAnyPublisher())
        }
    }
    
    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------
    
    func testSearchArticlesWithKeywordJohnson() {
        viewModel.updateSearchKeyword("Johnson")
        
        viewModel.statePublisher
            .sink { state in
                switch state {
                case .loaded(let articles):
                    XCTAssert(articles == self.mockSearchArticleResponseJohnson.response.results)

                case .loadingFailed(let error):
                    XCTAssertNil(error)
                    
                default: break
                }
            }
            .store(in: &cancellables)

        verify(mockArticleStore).searchArticles(keyword: "Johnson")
    }
    
    func testSearchArticlesWithKeywordJoe() {
        viewModel.updateSearchKeyword("Joe")
        
        viewModel.statePublisher
            .sink { state in
                switch state {
                case .loaded(let articles):
                    XCTAssert(articles == self.mockSearchArticleResponseJoe.response.results)

                case .loadingFailed(let error):
                    XCTAssertNil(error)
                    
                default: break
                }
            }
            .store(in: &cancellables)

        verify(mockArticleStore).searchArticles(keyword: "Joe")
    }
    
    func testUpdateSearchKeyword() {
        viewModel.updateSearchKeyword("J")
        XCTAssertTrue("J" == viewModel.searchKeyword)
        viewModel.updateSearchKeyword("Joe")
        XCTAssertTrue("Joe" == viewModel.searchKeyword)
        
        viewModel.statePublisher
            .sink { state in
                switch state {
                case .loaded(let articles):
                    XCTAssert(articles == self.mockSearchArticleResponseJohnson.response.results)

                case .loadingFailed(let error):
                    XCTAssertNil(error)
                    
                default: break
                }
            }
            .store(in: &cancellables)
        
        verify(mockArticleStore).searchArticles(keyword: "Joe")
    }
    
    func testSearchArticleJSONDecoding() throws {
        let mockJsonData = mockJsonSearchArticleResponse.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        XCTAssertNoThrow(try decoder.decode(SearchArticleResponse.self, from: mockJsonData))
    }
}
