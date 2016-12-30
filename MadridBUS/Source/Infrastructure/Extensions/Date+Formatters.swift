import Foundation

extension Date {
    static func from(string: String, using format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(abbreviation: "MET")
        formatter.dateFormat = format
        
        return formatter.date(from: string)
    }
    
    static func string(from date: Date, style: DateFormatter.Style, onlyTime: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(abbreviation: "MET")
        
        if onlyTime {
            formatter.timeStyle = style
            formatter.dateStyle = .none
        } else {
            formatter.dateStyle = style
        }
        
        return formatter.string(from: date)
    }
    
    static func string(from date: Date, using format: String) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(abbreviation: "MET")
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    static func timeString(from date: Date) -> String {
        var pattern = ""
        
        let locale = NSLocale.current
        let hourStyleToken = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if hourStyleToken.contains("a") {
            pattern = "hh:mm a"
        } else {
            pattern = "HH:mm a"
        }
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(abbreviation: "MET")
        formatter.dateFormat = pattern
        
        return formatter.string(from: date)
    }
}
