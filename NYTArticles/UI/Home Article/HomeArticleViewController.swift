import UIKit

protocol HomeArticleViewControllerDelegate: NSObjectProtocol {
    func homeArticleViewControllerDidSelectCell(_ viewController: HomeArticleViewController,
                                                searchType: SearchType)
}

class HomeArticleViewController: UIViewController {
    class func fromStoryboard() -> (UINavigationController, HomeArticleViewController) {
        let navigationController = UIStoryboard(name: "HomeArticle", bundle: .main).instantiateVC() as! UINavigationController
        let viewController = navigationController.topViewController
        return (navigationController, viewController as! HomeArticleViewController)
    }
    
    //----------------------------------------
    // MARK: - Lifecycle
    //----------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.accessibilityIdentifier = "home_collection_view"
        
        setUpMinimalBackBarButtonItem()
        configureViews()
    }
    
    //----------------------------------------
    // MARK: - Configure Views
    //----------------------------------------
    
    private func configureViews() {
        navigationController?.navigationBar.isHidden = false
        
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.register(cellType: HomeArticleCell.self)
        collectionView.register(UINib(nibName: HomeArticleHeaderView.reuseIdentifier, bundle: .main),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HomeArticleHeaderView.reuseIdentifier)
        
        applySnapshot(sections: viewModel.homeArticleContent)
    }
    
    //----------------------------------------
    // MARK: - UI collection view layout
    //----------------------------------------
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var cellSize: CGSize!
            var itemSize: NSCollectionLayoutSize!
            var group: NSCollectionLayoutGroup!
            var headerSize: CGSize!
            var item: NSCollectionLayoutItem!
            var section: NSCollectionLayoutSection!
            let containerWidth = layoutEnvironment.container.contentSize.width
                        
            switch Section(rawValue: sectionIndex) {
            case .search,
                    .popular:
                headerSize = HomeArticleHeaderView.sizeThatFits(width: containerWidth)
                cellSize = HomeArticleCell.sizeThatFits(width: containerWidth)
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .absolute(cellSize.height))
                item = NSCollectionLayoutItem(layoutSize: itemSize)
                group = .vertical(layoutSize: itemSize, subitems: [item])
                
                let headerLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                              heightDimension: .absolute(headerSize.height))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerLayoutSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                header.contentInsets = .zero
                section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                
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
    
    private func applySnapshot(sections: HomeArticleContent, animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.search,
                                 .popular])
        
        snapshot.appendItems(viewModel.homeArticleContent.search, toSection: .search)
        snapshot.appendItems(viewModel.homeArticleContent.popular, toSection: .popular)

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func createDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeArticleCell.self), for: indexPath) as? HomeArticleCell
                    cell?.bindViewModel(viewModel: HomeArticleCellViewModel(labelString: (item as! SearchType).localizedString))
                
                return cell
            })

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }

            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: HomeArticleHeaderView.reuseIdentifier,
                                                                       for: indexPath) as! HomeArticleHeaderView
            
            view.bindViewModel(viewModel: HomeArticleHeaderViewModel(headerString: section.stringRawValue))
            
            return view
        }
        
        return dataSource
    }

    private lazy var dataSource = createDataSource()
    
    //----------------------------------------
    // MARK: - Delegate
    //----------------------------------------
    
    weak var delegate: HomeArticleViewControllerDelegate?
    
    //----------------------------------------
    // MARK: - View model
    //----------------------------------------
    
    var viewModel: HomeArticleViewModel!
    
    //----------------------------------------
    // MARK: - Section
    //----------------------------------------
    
    enum Section: Int, Hashable {
        case search
        case popular
        
        var stringRawValue: String {
            switch self {
            case .search: return NSLocalizedString("search", comment: "text")
            case .popular: return NSLocalizedString("popular", comment: "text")
            }
        }
    }
    
    //----------------------------------------
    // MARK: - Type aliases
    //----------------------------------------
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------
    
    @IBOutlet private var collectionView: UICollectionView!
}

//----------------------------------------
// MARK: - UICollectionView Delegate
//----------------------------------------

extension HomeArticleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .search:
            delegate?.homeArticleViewControllerDidSelectCell(self, searchType: .newSearch)
            
        case .popular:
            delegate?.homeArticleViewControllerDidSelectCell(self, searchType: viewModel.homeArticleContent.popular[indexPath.row])
            
        default: break
        }
    }
}
