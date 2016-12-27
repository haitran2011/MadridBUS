import Foundation
import ObjectMapper

final class BusNodeBasicInfo: Mappable {
    var id: Int = 0
    var name: String = ""
    var lines: [String] = []
    var wifi: Bool = false
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["node"]
        name <- map["name"]
        lines <- map["lines"]
        wifi <- map["Wifi"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
