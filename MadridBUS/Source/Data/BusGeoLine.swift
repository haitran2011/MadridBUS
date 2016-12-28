import Foundation
import ObjectMapper

enum BusGeoLineDirection: String {
    case forward = "A"
    case backward = "B"
    case undetermined = "Z"
}

struct BusGeoLineFrequency {
    var min: Int
    var max: Int
}

final class BusGeoLine: Mappable {
    var name: String = ""
    var dayType: BusDayType = .undetermined
    var header: String = ""
    var terminus: String = ""
    var direction: BusGeoLineDirection = .undetermined
    var frequency: BusGeoLineFrequency = BusGeoLineFrequency(min: 0, max: 0)
    var startTime: Date = Date()
    var endTime: Date = Date()
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm"
        
        var maxFrequency = 0
        maxFrequency <- map["maximumFrequency"]
        
        var minFrequency = 0
        minFrequency <- map["minimumFrequency"]
        
        name <- map["name"]
        dayType <- (map["TipoDia"], EnumTransform<BusDayType>())
        header <- map["headerA"]
        terminus <- map["headerB"]
        direction <- (map["direction"], EnumTransform<BusGeoLineDirection>())
        frequency = BusGeoLineFrequency(min: minFrequency, max: maxFrequency)
        startTime <- (map["startTime"], DateFormatterTransform(dateFormatter: dateFormatter))
        endTime <- (map["stopTime"], DateFormatterTransform(dateFormatter: dateFormatter))
    }
}