import Foundation

final class HomeArticleViewModel: NSObject {
    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------
    
    var homeArticleContent: HomeArticleContent = HomeArticleContent(
        search: [.newSearch],
        popular: [.mostViewed,
                  .mostShared,
                  .mostEmailed]
    )
}
