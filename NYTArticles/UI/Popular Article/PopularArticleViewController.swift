import UIKit
import Combine

protocol PopularArticleViewControllerDelegate: NSObjectProtocol {
    func popularArticleViewControllerDidFinish(_ viewController: PopularArticleViewController)
}

class PopularArticleViewController: UIViewController {
    class func fromStoryboard() -> (UINavigationController, PopularArticleViewController) {
        let navigationController = UIStoryboard(name: "PopularArticle", bundle: .main).instantiateVC() as! UINavigationController
        let viewController = navigationController.topViewController
        return (navigationController, viewController as! PopularArticleViewController)
    }
    
    //----------------------------------------
    // MARK: - Lifecycle
    //----------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.accessibilityIdentifier = "article_popular_collection_view"

        configureViews()
        bindViewModel()
    }
    
    //----------------------------------------
    // MARK: - Bind view model
    //----------------------------------------
    
    private func bindViewModel() {
        viewModel.statePublisher
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .loaded(let articles):
                    self.applySnapshot(articleList: articles)
                    
                default:
                    break
                }
                
                self.statefulPlaceholderView.bind(state)
            }.store(in: &cancellables)
    }
    
    //----------------------------------------
    // MARK: - Configure views
    //----------------------------------------
    
    private func configureViews() {
        navigationItem.title = viewModel.searchType.localizedString

        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.register(cellType: ArticleCell.self)
        
        applySnapshot(articleList: [])
    }
    
    //----------------------------------------
    // MARK: - UI collection view layout
    //----------------------------------------
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var cellSize: CGSize!
            var itemSize: NSCollectionLayoutSize!
            var group: NSCollectionLayoutGroup!
            var item: NSCollectionLayoutItem!
            var section: NSCollectionLayoutSection!
            let containerWidth = layoutEnvironment.container.contentSize.width
                        
            switch Section(rawValue: sectionIndex) {
            case .main:
                cellSize = HomeArticleCell.sizeThatFits(width: containerWidth)
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(cellSize.height))
                item = NSCollectionLayoutItem(layoutSize: itemSize)
                group = .vertical(layoutSize: itemSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                
            default:
                fatalError()
            }
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    //----------------------------------------
    // MARK: - UI collection view data source
    //----------------------------------------
    
    private func applySnapshot(articleList: [PopularArticle], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(articleList, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func createDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArticleCell.self), for: indexPath) as! ArticleCell
                let article = item as! PopularArticle
                cell.bindViewModel(
                    viewModel: ArticleCellViewModel(titleText: article.title,
                                                          date: nil,
                                                          dateString: article.publishedDate)
                )
                
                return cell
            })
        
        return dataSource
    }

    private lazy var dataSource = createDataSource()
    
    //----------------------------------------
    // MARK: - Delegate
    //----------------------------------------
    
    weak var delegate: PopularArticleViewControllerDelegate?
    
    //----------------------------------------
    // MARK: - View model
    //----------------------------------------
    
    var viewModel: PopularArticleViewModel!
    
    //----------------------------------------
    // MARK: - Section
    //----------------------------------------
    
    enum Section: Int {
        case main
    }
    
    //----------------------------------------
    // MARK: - Type aliases
    //----------------------------------------
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
        
    private var cancellables = Set<AnyCancellable>()

    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------
    
    @IBOutlet private var statefulPlaceholderView: StatefulPlaceholderView!
        
    @IBOutlet private var collectionView: UICollectionView!
}
