import Foundation
import ObjectMapper

final class BusGroup: Mappable {
    var id: String = ""
    var description: String = ""
    
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["groupId"]
        description <- map["groupDescription"]
    }
}
