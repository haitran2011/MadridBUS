import Foundation
import ObjectMapper

enum BusLineTimeTableDirection: String {
    case forward = "2"
    case backward = "1"
    case undefined = "0"
}

final class BusLineTimeTableItem: Mappable {
    var date: Date = Date()
    var dayType: BusDayType = .undefined
    var line: String = ""
    var trip: String = ""
    var direction: BusLineTimeTableDirection = .undefined
    var startTime: Date = Date()
    var endTime: Date = Date()
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "h:mm:ss"
        
        date <- (map["date"], DateFormatterTransform(dateFormatter: dateFormatter))
        dayType <- (map["typeDay"], EnumTransform<BusDayType>())
        line <- map["line"]
        trip <- map["trip"]
        direction <- (map["direction"], EnumTransform<BusLineTimeTableDirection>())
        startTime <- (map["timeFirst"], DateFormatterTransform(dateFormatter: hourFormatter))
        endTime <- (map["timeEnd"], DateFormatterTransform(dateFormatter: hourFormatter))
    }
}
