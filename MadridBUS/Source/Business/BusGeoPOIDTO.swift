import Foundation
import ObjectMapper

final class BusGeoPOIDTO: DTO {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var radius: Int = 0
    var language: String = ""
    
    init(latitude: Double, longitude: Double, radius: Int, language: Language = .spanish) {
        super.init()
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.language = language.rawValue
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        radius <- map["Radius"]
        language <- map["cultureInfo"]
    }
}
