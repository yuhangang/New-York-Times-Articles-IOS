import Foundation

// Service container for user by UI level code.
//
// The service container's service accessors should only be accessed on the main thread.

class ServiceContainer {
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init() { }
    
    //----------------------------------------
    // MARK: - Services
    //----------------------------------------
    
    private var _networkRequestManager: NetworkRequestManager?
    var networkRequestManager: NetworkRequestManager {
        if _networkRequestManager == nil {
            _networkRequestManager = NetworkRequestManager()
        }
        
        return _networkRequestManager!
    }
    
    private var _articleStore: ArticleStore?
    var articleStore: ArticleStore {
        if _articleStore == nil {
            _articleStore = ArticleStore(networkRequestManager: networkRequestManager)
        }
        
        return _articleStore!
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let userDefaults: UserDefaults = UserDefaults.standard
}
