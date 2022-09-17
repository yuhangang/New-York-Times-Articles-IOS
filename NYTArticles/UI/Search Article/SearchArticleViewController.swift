import UIKit
import Combine

protocol SearchArticleViewControllerDelegate: NSObjectProtocol {
    func SearchArticleViewControllerDidFinish(_ viewController: SearchArticleViewController)
}

class SearchArticleViewController: UIViewController {
    class func fromStoryboard() -> (UINavigationController, SearchArticleViewController) {
        let navigationController = UIStoryboard(name: "SearchArticle", bundle: .main).instantiateVC() as! UINavigationController
        let viewController = navigationController.topViewController
        return (navigationController, viewController as! SearchArticleViewController)
    }
    
    //----------------------------------------
    // MARK: - Lifecycle
    //----------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.accessibilityIdentifier = "article_search_collection_view"

        configureViews()
        configureSearchBar()
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
                    self.applySnapshot(searchArticles: articles)
                    self.emptyCollectionViewPlaceholderLabel.isHidden = !articles.isEmpty || self.viewModel.searchKeyword == nil
                    self.statefulPlaceholderView.bind(state)
                    
                default:
                    self.statefulPlaceholderView.bind(state)
                }
            }.store(in: &cancellables)
    }
    
    //----------------------------------------
    // MARK: - Configure views
    //----------------------------------------
    
    private func configureViews() {
        hideKeyboardWhenTappedAround()
        
        navigationItem.title = SearchType.newSearch.localizedString
        
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.register(
            UINib(nibName: String(describing: ArticleCell.self), bundle: nil),
            forCellWithReuseIdentifier: String(describing: ArticleCell.self)
        )
        
        applySnapshot(searchArticles: [])
    }
    
    private func configureSearchBar() {
        searchBar.searchTextDidChange
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                
                self.viewModel.updateSearchKeyword(text.isEmpty ? nil : text)
            }
            .store(in: &cancellables)
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
    
    private func applySnapshot(searchArticles: [SearchArticle], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(searchArticles, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func createDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArticleCell.self), for: indexPath) as! ArticleCell
                let article = item as! SearchArticle
                cell.bindViewModel(
                    viewModel: ArticleCellViewModel(titleText: article.headline?.printHeadline ?? "N/A",
                                                          date: article.publishedDate,
                                                          dateString: nil)
                )
                
                return cell
            })
        
        return dataSource
    }

    private lazy var dataSource = createDataSource()
    
    //----------------------------------------
    // MARK: - Delegate
    //----------------------------------------
    
    weak var delegate: SearchArticleViewControllerDelegate?
    
    //----------------------------------------
    // MARK: - View model
    //----------------------------------------
    
    var viewModel: SearchArticleViewModel!
    
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
    
    @IBOutlet private var emptyCollectionViewPlaceholderLabel: UILabel!
    
    @IBOutlet private var statefulPlaceholderView: StatefulPlaceholderView!
    
    @IBOutlet private var searchBar: SearchBar!
    
    @IBOutlet private var collectionView: UICollectionView!
}
