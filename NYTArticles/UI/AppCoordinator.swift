import UIKit

class AppCoordinator: NSObject {
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(serviceContainer: ServiceContainer, mainViewController: MainViewController) {
        self.serviceContainer = serviceContainer
        self.mainViewController = mainViewController
        
        super.init()
    }
    
    //----------------------------------------
    // MARK: - Start
    //----------------------------------------
    
    func startMainFlow() {        
        let (navigationController, homeArticleViewController) = HomeArticleViewController.fromStoryboard()
        homeArticleViewController.viewModel = HomeArticleViewModel()
        mainViewController.addChild(navigationController)
        mainViewController.view.addSubview(navigationController.view)
        NSLayoutConstraint.activate(navigationController.view.constraints(pinningEdgesTo: mainViewController.view))
        navigationController.didMove(toParent: mainViewController)
        
        let articleCoordinator = ArticleCoordinator(articleStore: serviceContainer.articleStore,
                                                    homeArticleViewController: homeArticleViewController)
        articleCoordinator.delegate = self
        articleCoordinator.start()
        
        self.articleCoordinator = articleCoordinator
        self.activeViewController = homeArticleViewController
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let serviceContainer: ServiceContainer
    
    private let mainViewController: MainViewController
    
    private var articleCoordinator: ArticleCoordinator?
    
    private var activeViewController: UIViewController?
}

//----------------------------------------
// MARK: - Article coordinator delegate
//----------------------------------------

extension AppCoordinator: ArticleCoordinatorDelegate {
    func articleCoordinatorDidFinish() {
        self.articleCoordinator = nil
    }
}
