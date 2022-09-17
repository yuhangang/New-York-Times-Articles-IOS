import Foundation

final class ArticleCellViewModel: NSObject {
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(titleText: String, date: Date?, dateString: String?) {
        self.titleText = titleText
        self.date = date
        self.dateString = dateString
    }
    
    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------
    
    var formattedDate: String? {
        if let dateString = dateString,
           let date = NYTDateFormatter.dateFromString(string: dateString, forDateFormat: "yyyy-MM-dd") {
            return NYTDateFormatter.formatDatePresentation(date: date, to: "dd MMMM yyyy")
        } else if let date = date {
            return NYTDateFormatter.formatDatePresentation(date: date, to: "dd MMMM yyyy")
        }
        return nil
    }
    
    let titleText: String
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let dateString: String?
    
    private let date: Date?
}
