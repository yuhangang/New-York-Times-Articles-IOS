import XCTest
import Cuckoo
import Combine
@testable import NYTArticles

class NetworkRequestManagerTest: XCTestCase {
    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------
    
    var mockNetworkRequestManager: MockNetworkRequestManager!
    
    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------
    
    override func setUp() {
        mockNetworkRequestManager = MockNetworkRequestManager()
    }
    
    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------
    
    func testNetworkRequestManagerConfiguration() throws {
        XCTAssertEqual(mockNetworkRequestManager.apiBaseURL, AppConstants.apiEndpoint)
        XCTAssertEqual(mockNetworkRequestManager.apiKey, AppConstants.apiKey)
        XCTAssertNotNil(mockNetworkRequestManager.urlSession)
    }
}

//----------------------------------------
// MARK: - URLRequest.HTTPMethod Matchable
//----------------------------------------

extension URLRequest.HTTPMethod: Matchable {
    public var matcher: ParameterMatcher<URLRequest.HTTPMethod> {
        return ParameterMatcher {
            return $0 == self
        }
    }
}
