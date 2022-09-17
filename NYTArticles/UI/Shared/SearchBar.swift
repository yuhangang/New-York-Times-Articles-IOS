import UIKit
import Combine

class SearchBar: UISearchBar, UISearchBarDelegate {
    //----------------------------------------
    // MARK: - Lifecycle
    //----------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
    }
    
    //----------------------------------------
    // MARK: - UISearchBar delegate
    //----------------------------------------
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextDidChange.send(searchText)
    }
    
    //----------------------------------------
    // MARK: - Combine publishers
    //----------------------------------------
    
    var searchTextDidChange = PassthroughSubject<String, Never>()
}
