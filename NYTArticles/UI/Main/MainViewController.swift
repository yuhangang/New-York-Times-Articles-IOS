import UIKit

class MainViewController: UIViewController {
    //----------------------------------------
    // MARK: - Lifecycle
    //----------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .heavy)
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.white
    }
}
