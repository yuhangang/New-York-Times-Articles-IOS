import UIKit

final class HomeArticleHeaderView: UICollectionReusableView, NibReusable {
    //----------------------------------------
    // MARK: - Lifecycle
    //----------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessibilityIdentifier = "home_section_header"
    }
    
    //----------------------------------------
    // MARK: - Bind view model
    //----------------------------------------
    
    func bindViewModel(viewModel: HomeArticleHeaderViewModel) {
        headerLabel.text = viewModel.headerString
    }
    
    //----------------------------------------
    // MARK: - Sizing
    //----------------------------------------
    
    static func sizeThatFits(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 40.0)
    }
    
    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------
    
    @IBOutlet private var headerLabel: UILabel!
}
