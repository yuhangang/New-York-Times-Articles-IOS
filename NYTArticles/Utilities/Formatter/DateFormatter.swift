import Foundation

class NYTDateFormatter {
    static func formatDatePresentation(date: Date, to dateFormat: String) -> String {
        let formattedDate = DateFormatter()
        formattedDate.dateFormat = dateFormat

        return formattedDate.string(from: date)
    }
    
    static func formatTimePresentation(date: Date, to dateFormat: String) -> String {
        let formattedTime = DateFormatter()
        formattedTime.dateFormat = dateFormat

        return formattedTime.string(from: date)
    }
    
    static func dateFromString(string: String, forDateFormat format: String? = nil) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? "yyyy-MM-dd HH:mm:ss +zzzz"

        return dateFormatter.date(from: string)
    }
    
    static func stringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"

        return dateFormatter.string(from: date)
    }
}
