import Foundation
import ObjectMapper

final class POIAttributes: Mappable {
    var id: Int = 0
    var type: Int = 0
    var name: String = ""
    var address: String = ""
    var addressNumber: Int = 0
    var phoneNumber: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["poiId"]
        type <- map["type"]
        name <- map["name"]
        address <- map["address"]
        addressNumber <- map["streetNumber"]
        phoneNumber <- map["phoneNumber"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}

final class POI: Mappable {
    var attributes: POIAttributes = POIAttributes()
    
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        attributes <- map["attributes"]
    }
}
