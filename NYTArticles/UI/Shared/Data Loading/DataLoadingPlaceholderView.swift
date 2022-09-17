import UIKit

protocol DataLoadingPlaceholderViewDelegate: AnyObject {
    func dataLoadingPlaceholderViewRetryButtonDidTap(_ dataLoadingPlaceholderView: DataLoadingPlaceholderView)
}

// Placeholder view that binds `DataLoadingViewModelState`.
class DataLoadingPlaceholderView: UIView, NibLoadable {
    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    override init(frame: CGRect) {
        super.init(frame: frame)

        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        sharedInit()
    }

    private func sharedInit() {
        let view = Bundle.main.loadNibNamed(String(describing: DataLoadingPlaceholderView.self),
                                            owner: self,
                                            options: nil)?.first as! UIView

        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(view.constraints(pinningEdgesTo: self))
        
        activityIndicatorView.hidesWhenStopped = true
        
        retryButton.cornerRadius = 4
        retryButton.layer.borderWidth = 1
        retryButton.layer.borderColor = UIColor.black.cgColor
    }

    //----------------------------------------
    // MARK:- View bindings
    //----------------------------------------

    func bind<T>(_ state: DataLoadingViewModelState<T>) {
        switch state {
        case .loading:
            isHidden = false
            activityIndicatorView.startAnimating()
            
            imageView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
            
        case .loadingFailed(let error):
            isHidden = false
            activityIndicatorView.stopAnimating()
            
            imageView.isHidden = false
            titleLabel.isHidden = false
            subtitleLabel.isHidden = false
            retryButton.isHidden = false
            
            // Update view based on error.
            let error = error as? AppError
            if error == AppError.network {
                imageView.image = UIImage(systemName: "wifi.exclamationmark")
                titleLabel.text = "Connection Error"
                subtitleLabel.text = "Error loading data"
            } else {
                imageView.image = UIImage(systemName: "xmark.octagon")
                titleLabel.text = "Something went wrong"
                subtitleLabel.text = "Please try again later"
            }
            
        case .retryingLoad:
            isHidden = false
            activityIndicatorView.startAnimating()
            
            imageView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
            
        case .loaded:
            isHidden = true
            activityIndicatorView.stopAnimating()
            
            imageView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
        
        case .manualReloading:
            isHidden = true
            activityIndicatorView.stopAnimating()

            imageView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
            
        case .manualReloadingFailed:
            isHidden = true
            activityIndicatorView.stopAnimating()

            imageView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
        }
    }
    
    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------
    
    @IBAction func retryButtonDidTap(_ sender: UIButton) {
        delegate?.dataLoadingPlaceholderViewRetryButtonDidTap(self)
    }
    
    func setEmptyPlaceholder(withRetryOption: Bool = false) {
        isHidden = false
        activityIndicatorView.stopAnimating()
        
        imageView.isHidden = false
        titleLabel.isHidden = false
        subtitleLabel.isHidden = !withRetryOption
        retryButton.isHidden = !withRetryOption
        
        imageView.image = UIImage(systemName: "xmark.octagon")
        titleLabel.text = "Something went wrong"
        subtitleLabel.text = "Please try again later"
    }

    //----------------------------------------
    // MARK:- Delegate
    //----------------------------------------

    weak var delegate: DataLoadingPlaceholderViewDelegate?
    
    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var retryButton: UIButton!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
}
