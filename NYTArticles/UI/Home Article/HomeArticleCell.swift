import UIKit

final class HomeArticleCell: UICollectionViewCell, NibReusable {
    //----------------------------------------
    // MARK: - Bind view model
    //----------------------------------------
    
    func bindViewModel(viewModel: HomeArticleCellViewModel) {
        textLabel.text = viewModel.labelString
    }
    
    //----------------------------------------
    // MARK: - Sizing
    //----------------------------------------
    
    static func sizeThatFits(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 60.0)
    }
    
    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------
    
    @IBOutlet private var textLabel: UILabel!
}
