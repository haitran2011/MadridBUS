import Foundation
import ObjectMapper

enum BusGeoPositionType: Int {
    case real = 2
    case estimated = 1
}

final class BusGeoNodeArrival: Mappable {
    var nodeId: Int = 0
    var lineId: String = ""
    var busId: String = ""
    var isHeader: Bool = false
    var destination: String = ""
    var ETA: Int = 0
    var distance: Int = 0
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        nodeId <- map["stopId"]
        lineId <- map["lineId"]
        busId <- map["busId"]
        isHeader <- map["isHead"]
        destination <- map["destination"]
        ETA <- map["busTimeLeft"]
        distance <- map["busDistance"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
