// MARK: - Mocks generated from file: NYTArticles/Services/Articles/ArticleStore.swift at 2022-03-18 08:49:05 +0000


import Cuckoo
@testable import NYTArticles

import Combine
import Foundation


 class MockArticleStore: ArticleStore, Cuckoo.ClassMock {
    
     typealias MocksType = ArticleStore
    
     typealias Stubbing = __StubbingProxy_ArticleStore
     typealias Verification = __VerificationProxy_ArticleStore

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ArticleStore?

     func enableDefaultImplementation(_ stub: ArticleStore) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func searchArticles(keyword: String) -> AnyPublisher<[SearchArticle], Error> {
        
    return cuckoo_manager.call("searchArticles(keyword: String) -> AnyPublisher<[SearchArticle], Error>",
            parameters: (keyword),
            escapingParameters: (keyword),
            superclassCall:
                
                super.searchArticles(keyword: keyword)
                ,
            defaultCall: __defaultImplStub!.searchArticles(keyword: keyword))
        
    }
    
    
    
     override func fetchPopularArticles(searchType: SearchType) -> AnyPublisher<[PopularArticle], Error> {
        
    return cuckoo_manager.call("fetchPopularArticles(searchType: SearchType) -> AnyPublisher<[PopularArticle], Error>",
            parameters: (searchType),
            escapingParameters: (searchType),
            superclassCall:
                
                super.fetchPopularArticles(searchType: searchType)
                ,
            defaultCall: __defaultImplStub!.fetchPopularArticles(searchType: searchType))
        
    }
    

	 struct __StubbingProxy_ArticleStore: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func searchArticles<M1: Cuckoo.Matchable>(keyword: M1) -> Cuckoo.ClassStubFunction<(String), AnyPublisher<[SearchArticle], Error>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: keyword) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockArticleStore.self, method: "searchArticles(keyword: String) -> AnyPublisher<[SearchArticle], Error>", parameterMatchers: matchers))
	    }
	    
	    func fetchPopularArticles<M1: Cuckoo.Matchable>(searchType: M1) -> Cuckoo.ClassStubFunction<(SearchType), AnyPublisher<[PopularArticle], Error>> where M1.MatchedType == SearchType {
	        let matchers: [Cuckoo.ParameterMatcher<(SearchType)>] = [wrap(matchable: searchType) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockArticleStore.self, method: "fetchPopularArticles(searchType: SearchType) -> AnyPublisher<[PopularArticle], Error>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_ArticleStore: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func searchArticles<M1: Cuckoo.Matchable>(keyword: M1) -> Cuckoo.__DoNotUse<(String), AnyPublisher<[SearchArticle], Error>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: keyword) { $0 }]
	        return cuckoo_manager.verify("searchArticles(keyword: String) -> AnyPublisher<[SearchArticle], Error>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func fetchPopularArticles<M1: Cuckoo.Matchable>(searchType: M1) -> Cuckoo.__DoNotUse<(SearchType), AnyPublisher<[PopularArticle], Error>> where M1.MatchedType == SearchType {
	        let matchers: [Cuckoo.ParameterMatcher<(SearchType)>] = [wrap(matchable: searchType) { $0 }]
	        return cuckoo_manager.verify("fetchPopularArticles(searchType: SearchType) -> AnyPublisher<[PopularArticle], Error>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class ArticleStoreStub: ArticleStore {
    

    

    
    
    
     override func searchArticles(keyword: String) -> AnyPublisher<[SearchArticle], Error>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<[SearchArticle], Error>).self)
    }
    
    
    
     override func fetchPopularArticles(searchType: SearchType) -> AnyPublisher<[PopularArticle], Error>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<[PopularArticle], Error>).self)
    }
    
}


// MARK: - Mocks generated from file: NYTArticles/Services/Primary/NetworkRequestManager.swift at 2022-03-18 08:49:05 +0000


import Cuckoo
@testable import NYTArticles

import Combine
import Foundation


 class MockNetworkRequestManager: NetworkRequestManager, Cuckoo.ClassMock {
    
     typealias MocksType = NetworkRequestManager
    
     typealias Stubbing = __StubbingProxy_NetworkRequestManager
     typealias Verification = __VerificationProxy_NetworkRequestManager

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: NetworkRequestManager?

     func enableDefaultImplementation(_ stub: NetworkRequestManager) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func apiRequest(_ method: URLRequest.HTTPMethod, _ path: String, queryItems: [URLQueryItem]?, requestBody: Data?) -> AnyPublisher<Data, Error> {
        
    return cuckoo_manager.call("apiRequest(_: URLRequest.HTTPMethod, _: String, queryItems: [URLQueryItem]?, requestBody: Data?) -> AnyPublisher<Data, Error>",
            parameters: (method, path, queryItems, requestBody),
            escapingParameters: (method, path, queryItems, requestBody),
            superclassCall:
                
                super.apiRequest(method, path, queryItems: queryItems, requestBody: requestBody)
                ,
            defaultCall: __defaultImplStub!.apiRequest(method, path, queryItems: queryItems, requestBody: requestBody))
        
    }
    
    
    
     override func authorizedApiRequest(_ method: URLRequest.HTTPMethod, _ path: String, queryItems: [URLQueryItem]?, requestBody: Data?) -> AnyPublisher<Data, Error> {
        
    return cuckoo_manager.call("authorizedApiRequest(_: URLRequest.HTTPMethod, _: String, queryItems: [URLQueryItem]?, requestBody: Data?) -> AnyPublisher<Data, Error>",
            parameters: (method, path, queryItems, requestBody),
            escapingParameters: (method, path, queryItems, requestBody),
            superclassCall:
                
                super.authorizedApiRequest(method, path, queryItems: queryItems, requestBody: requestBody)
                ,
            defaultCall: __defaultImplStub!.authorizedApiRequest(method, path, queryItems: queryItems, requestBody: requestBody))
        
    }
    

	 struct __StubbingProxy_NetworkRequestManager: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func apiRequest<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable>(_ method: M1, _ path: M2, queryItems: M3, requestBody: M4) -> Cuckoo.ClassStubFunction<(URLRequest.HTTPMethod, String, [URLQueryItem]?, Data?), AnyPublisher<Data, Error>> where M1.MatchedType == URLRequest.HTTPMethod, M2.MatchedType == String, M3.OptionalMatchedType == [URLQueryItem], M4.OptionalMatchedType == Data {
	        let matchers: [Cuckoo.ParameterMatcher<(URLRequest.HTTPMethod, String, [URLQueryItem]?, Data?)>] = [wrap(matchable: method) { $0.0 }, wrap(matchable: path) { $0.1 }, wrap(matchable: queryItems) { $0.2 }, wrap(matchable: requestBody) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockNetworkRequestManager.self, method: "apiRequest(_: URLRequest.HTTPMethod, _: String, queryItems: [URLQueryItem]?, requestBody: Data?) -> AnyPublisher<Data, Error>", parameterMatchers: matchers))
	    }
	    
	    func authorizedApiRequest<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable>(_ method: M1, _ path: M2, queryItems: M3, requestBody: M4) -> Cuckoo.ClassStubFunction<(URLRequest.HTTPMethod, String, [URLQueryItem]?, Data?), AnyPublisher<Data, Error>> where M1.MatchedType == URLRequest.HTTPMethod, M2.MatchedType == String, M3.OptionalMatchedType == [URLQueryItem], M4.OptionalMatchedType == Data {
	        let matchers: [Cuckoo.ParameterMatcher<(URLRequest.HTTPMethod, String, [URLQueryItem]?, Data?)>] = [wrap(matchable: method) { $0.0 }, wrap(matchable: path) { $0.1 }, wrap(matchable: queryItems) { $0.2 }, wrap(matchable: requestBody) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockNetworkRequestManager.self, method: "authorizedApiRequest(_: URLRequest.HTTPMethod, _: String, queryItems: [URLQueryItem]?, requestBody: Data?) -> AnyPublisher<Data, Error>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_NetworkRequestManager: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func apiRequest<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable>(_ method: M1, _ path: M2, queryItems: M3, requestBody: M4) -> Cuckoo.__DoNotUse<(URLRequest.HTTPMethod, String, [URLQueryItem]?, Data?), AnyPublisher<Data, Error>> where M1.MatchedType == URLRequest.HTTPMethod, M2.MatchedType == String, M3.OptionalMatchedType == [URLQueryItem], M4.OptionalMatchedType == Data {
	        let matchers: [Cuckoo.ParameterMatcher<(URLRequest.HTTPMethod, String, [URLQueryItem]?, Data?)>] = [wrap(matchable: method) { $0.0 }, wrap(matchable: path) { $0.1 }, wrap(matchable: queryItems) { $0.2 }, wrap(matchable: requestBody) { $0.3 }]
	        return cuckoo_manager.verify("apiRequest(_: URLRequest.HTTPMethod, _: String, queryItems: [URLQueryItem]?, requestBody: Data?) -> AnyPublisher<Data, Error>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func authorizedApiRequest<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable>(_ method: M1, _ path: M2, queryItems: M3, requestBody: M4) -> Cuckoo.__DoNotUse<(URLRequest.HTTPMethod, String, [URLQueryItem]?, Data?), AnyPublisher<Data, Error>> where M1.MatchedType == URLRequest.HTTPMethod, M2.MatchedType == String, M3.OptionalMatchedType == [URLQueryItem], M4.OptionalMatchedType == Data {
	        let matchers: [Cuckoo.ParameterMatcher<(URLRequest.HTTPMethod, String, [URLQueryItem]?, Data?)>] = [wrap(matchable: method) { $0.0 }, wrap(matchable: path) { $0.1 }, wrap(matchable: queryItems) { $0.2 }, wrap(matchable: requestBody) { $0.3 }]
	        return cuckoo_manager.verify("authorizedApiRequest(_: URLRequest.HTTPMethod, _: String, queryItems: [URLQueryItem]?, requestBody: Data?) -> AnyPublisher<Data, Error>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class NetworkRequestManagerStub: NetworkRequestManager {
    

    

    
    
    
     override func apiRequest(_ method: URLRequest.HTTPMethod, _ path: String, queryItems: [URLQueryItem]?, requestBody: Data?) -> AnyPublisher<Data, Error>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Data, Error>).self)
    }
    
    
    
     override func authorizedApiRequest(_ method: URLRequest.HTTPMethod, _ path: String, queryItems: [URLQueryItem]?, requestBody: Data?) -> AnyPublisher<Data, Error>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Data, Error>).self)
    }
    
}

