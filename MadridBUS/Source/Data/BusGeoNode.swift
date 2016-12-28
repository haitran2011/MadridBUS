import Foundation
import ObjectMapper

final class BusGeoNode: Mappable {
    var id: String = ""
    var name: String = ""
    var lines: [BusGeoLine] = []
    var address: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["stopId"]
        name <- map["name"]
        lines <- map["line"]
        address <- map["postalAddress"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
