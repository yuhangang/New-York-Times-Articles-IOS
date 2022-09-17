import UIKit

extension UIStoryboard {
    
    func instantiateVC<T: UIViewController>() -> T {
        guard let controller = self.instantiateInitialViewController() as? T else {
          fatalError("ViewController is not of the expected class \(T.self).")
        }
        return controller
    }
}
