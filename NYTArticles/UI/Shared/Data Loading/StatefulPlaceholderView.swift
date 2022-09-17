import UIKit

protocol StatefulPlaceholderViewDelegate: AnyObject {
    func statefulPlaceholderViewRetryButtonDidTap(_ statefulPlaceholderView: StatefulPlaceholderView)
}

// Placeholder view that binds `StatefulViewModelState`.
class StatefulPlaceholderView: UIView {
    //----------------------------------------
    // MARK: - Initialization
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
        let view = Bundle.main.loadNibNamed(String(describing: StatefulPlaceholderView.self),
                                            owner: self,
                                            options: nil)?.first as! UIView

        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(view.constraints(pinningEdgesTo: self))
        backgroundColor = .clear
                
        retryButton.cornerRadius = 4
        retryButton.layer.borderWidth = 1
        retryButton.layer.borderColor = UIColor.black.cgColor
    }
    
    //----------------------------------------
    // MARK: - View bindings
    //----------------------------------------

    func bind<T>(_ state: State<T>) {
        switch state {
        case .loading:
            isHidden = false
            
            imageView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
            activityIndicatorView.startAnimating()
            
        case .loadingFailed(let error):
            isHidden = false
            
            imageView.isHidden = false
            titleLabel.isHidden = false
            subtitleLabel.isHidden = false
            retryButton.isHidden = false
            activityIndicatorView.stopAnimating()
            
            // Update view based on error.
            let error = error as? AppError
            if error == .network {
                imageView.image = UIImage(named: "wifi.exclamationmark")
                titleLabel.text = NSLocalizedString("error.offline.title",
                                                    comment: "error text")
                subtitleLabel.text = NSLocalizedString("error.offline.message",
                                                       comment: "error text")
            } else {
                imageView.image = UIImage(named: "exclamationmark.circle")
                titleLabel.text = NSLocalizedString("error.something_went_wrong",
                                                    comment: "error text")
                subtitleLabel.text = NSLocalizedString("error.please_try_again_later",
                                                       comment: "error text")
            }
            
        case .retryingLoad:
            isHidden = false
            
            imageView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
            activityIndicatorView.startAnimating()
            
        case .loaded:
            isHidden = true
            
            imageView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
            activityIndicatorView.stopAnimating()
        
        case .manualReloading:
            isHidden = true

            imageView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
            activityIndicatorView.startAnimating()
            
        case .manualReloadingFailed:
            isHidden = true

            imageView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
            activityIndicatorView.stopAnimating()
        }
    }
    
    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------
    
    @IBAction func retryButtonDidTap(_ sender: UIButton) {
        delegate?.statefulPlaceholderViewRetryButtonDidTap(self)
    }
    
    func setEmptyPlaceholder(withRetryOption: Bool = false) {
        isHidden = false
        
        imageView.isHidden = false
        titleLabel.isHidden = false
        subtitleLabel.isHidden = !withRetryOption
        retryButton.isHidden = !withRetryOption
        
        imageView.image = UIImage(named: "exclamationmark.circle")
        titleLabel.text = NSLocalizedString("placeholder.nothing_here_yet",
                                            comment: "placeholder text")
        subtitleLabel.text = NSLocalizedString("error.please_try_again_later",
                                               comment: "error text")
    }

    //----------------------------------------
    // MARK: - Delegate
    //----------------------------------------

    weak var delegate: StatefulPlaceholderViewDelegate?
    
    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var titleLabel: UILabel!
    
    @IBOutlet private var subtitleLabel: UILabel!
    
    @IBOutlet private var retryButton: UIButton!
        
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
}
