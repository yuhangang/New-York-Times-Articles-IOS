import UIKit

final class ArticleCell: UICollectionViewCell, NibReusable {
    //----------------------------------------
    // MARK: - Bind view model
    //----------------------------------------
    
    func bindViewModel(viewModel: ArticleCellViewModel) {
        titleLabel.text = viewModel.titleText
        subtitleLabel.text = viewModel.formattedDate
    }
    
    //----------------------------------------
    // MARK: - Sizing
    //----------------------------------------
    
    static func sizeThatFits(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 80.0)
    }
    
    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------
    
    @IBOutlet private var titleLabel: UILabel!
    
    @IBOutlet private var subtitleLabel: UILabel!
}
