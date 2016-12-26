import Foundation

extension Date {
    func components() -> (day: Int, month: Int, year: Int) {
        let unitFlags = Set<Calendar.Component>([.month, .day, .year])
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = calendar.dateComponents(unitFlags, from: self)

        return (day: components.day!, month: components.month!, year: components.year!)
    }
    
    static func create(day: Int, month: Int, year: Int) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        var components = DateComponents()
        components.calendar = calendar
        components.day = day
        components.month = month
        components.year = year
        
        return calendar.date(from: components)
    }
    
    static func nextWeek() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let todayWeekday = calendar.component(.weekday, from: Date())
        
        let addWeekdays = 7 - todayWeekday  // 7: Saturday number
        var components = DateComponents()
        components.weekday = addWeekdays
        
        return calendar.date(byAdding: components, to: Date())!
    }
}
