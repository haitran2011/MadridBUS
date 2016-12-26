import Foundation
import ObjectMapper

enum BusDayType: String {
    case labour = "LA"
    case saturday = "SA"
    case friday = "V"
    case holiday = "FE"
    case undetermined = ""
}

enum BusSeason: String {
    case winter = "IV"
    case springHolidays = "SS"
    case christmas = "NV"
    case lowSeason = "BJ"
    case summer = "VN"
    case undetermined = ""
}

final class BusCalendarItem: Mappable {
    var date: Date = Date()
    var dayType: BusDayType = .undetermined
    var season: BusSeason = .undetermined
    var onStrike: Bool = false
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm:ss"
        
        date <- (map["date"], DateFormatterTransform(dateFormatter: dateFormatter))
        dayType <- (map["dayType"], EnumTransform<BusDayType>())
        season <- (map["seasonTg"], EnumTransform<BusSeason>())
        onStrike <- map["strike"]
    }
}
