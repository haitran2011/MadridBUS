import Foundation
import ObjectMapper

enum BusNodeType: Int {
    case stopForward = 10
    case stopBackwards = 20
    case vertexForward = 19
    case vertexBackwards = 29
    case undefined = 0
}

final class BusNodeLocalized: Mappable {
    var id: Int = 0
    var line: Int = 0
    var type: BusNodeType = .undefined
    var name: String = ""
    var distanceToOrigin: Double = 0.0
    var distanceToPrevious: Double = 0.0
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["node"]
        line <- map["line"]
        type <- (map["secDetail"], EnumTransform<BusNodeType>())
        name <- map["name"]
        distanceToOrigin <- map["distance"]
        distanceToPrevious <- map["distancePreviousStop"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
