import Foundation

extension Date {
    static func from(string: String, using format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        
        return formatter.date(from: string)
    }
    
    static func string(from date: Date, style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.dateStyle = style
        
        return formatter.string(from: date)
    }
}
