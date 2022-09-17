import Foundation

final class HomeArticleHeaderViewModel: NSObject {
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(headerString: String) {
        self.headerString = headerString
    }
    
    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------
    
    let headerString: String
}
