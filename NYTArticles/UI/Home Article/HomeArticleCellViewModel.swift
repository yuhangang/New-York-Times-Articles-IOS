import UIKit

final class HomeArticleCellViewModel: NSObject {
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(labelString: String) {
        self.labelString = labelString
    }
    
    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------
    
    let labelString: String
}
