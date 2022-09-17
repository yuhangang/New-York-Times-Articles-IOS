import Foundation

protocol ArticleCoordinatorDelegate: NSObjectProtocol {
    func articleCoordinatorDidFinish()
}

class ArticleCoordinator: NSObject {
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(articleStore: ArticleStore, homeArticleViewController: HomeArticleViewController) {
        self.articleStore = articleStore
        self.homeArticleViewController = homeArticleViewController
    }
    
    //----------------------------------------
    // MARK: - Start
    //----------------------------------------
    
    func start() {
        homeArticleViewController.delegate = self
    }
    
    //----------------------------------------
    // MARK: - Delegate
    //----------------------------------------
    
    weak var delegate: ArticleCoordinatorDelegate?
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let articleStore: ArticleStore
    
    private let homeArticleViewController: HomeArticleViewController
    
    private var searchArticleViewController: SearchArticleViewController?
    
    private var popularArticleViewController: PopularArticleViewController?
}

//----------------------------------------
// MARK: - homeArticleViewController Delegate
//----------------------------------------

extension ArticleCoordinator: HomeArticleViewControllerDelegate {
    func homeArticleViewControllerDidSelectCell(_ homeArticleViewController: HomeArticleViewController, searchType: SearchType) {
        switch searchType {
        case .newSearch:
            let (_, searchArticleViewController) = SearchArticleViewController.fromStoryboard()
            searchArticleViewController.viewModel = SearchArticleViewModel(articleStore: articleStore)
            searchArticleViewController.delegate = self
            
            self.searchArticleViewController = searchArticleViewController
            homeArticleViewController.navigationController?.pushViewController(searchArticleViewController,
                                                                               animated: true)
            
        default:
            let (_, popularArticleViewController) = PopularArticleViewController.fromStoryboard()
            popularArticleViewController.viewModel = PopularArticleViewModel(articleStore: articleStore,
                                                                                           searchType: searchType)
            popularArticleViewController.delegate = self
            
            self.popularArticleViewController = popularArticleViewController
            homeArticleViewController.navigationController?.pushViewController(popularArticleViewController,
                                                                               animated: true)
        }
    }
}

//----------------------------------------
// MARK: - searchArticleViewController Delegate
//----------------------------------------

extension ArticleCoordinator: SearchArticleViewControllerDelegate {
    func SearchArticleViewControllerDidFinish(_ searchArticleViewController: SearchArticleViewController) {
        self.searchArticleViewController = nil
    }
}

//----------------------------------------
// MARK: - popularArticleViewController Delegate
//----------------------------------------

extension ArticleCoordinator: PopularArticleViewControllerDelegate {
    func popularArticleViewControllerDidFinish(_ popularArticleViewController: PopularArticleViewController) {
        self.popularArticleViewController = nil
    }
}
