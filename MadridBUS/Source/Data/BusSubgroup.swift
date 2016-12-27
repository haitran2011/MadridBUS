import Foundation
import ObjectMapper

final class BusSubgroup: Mappable {
    var groupId: String = ""
    var id: String = ""
    var description: String = ""
    
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        groupId <- map["groupId"]
        id <- map["subGroupId"]
        description <- map["groupDescription"]
    }
}
