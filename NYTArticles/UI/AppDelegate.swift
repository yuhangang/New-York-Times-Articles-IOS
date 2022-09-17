import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    //----------------------------------------
    // MARK: - Application lifecycle
    //----------------------------------------

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Create and start the overall app coordinator.
        let mainViewController = window!.rootViewController as! MainViewController
        self.serviceContainer = ServiceContainer()
        appCoordinator = AppCoordinator(serviceContainer: serviceContainer,
                                        mainViewController: mainViewController)
        appCoordinator.startMainFlow()

        return true
    }
    
    //----------------------------------------
    // MARK: - Application window
    //----------------------------------------
    
    var window: UIWindow?

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    /// Root level app coordinator.
    private var appCoordinator: AppCoordinator!
    
    private var serviceContainer: ServiceContainer!
}
