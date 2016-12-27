import Foundation
import ObjectMapper

final class BusLineBasicInfo: Mappable {
    var subgroupId: String = ""
    var id: String = ""
    var name: String = ""
    var header: String = ""
    var terminus: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        subgroupId <- map["groupNumber"]
        id <- map["line"]
        name <- map["label"]
        header <- map["nameA"]
        terminus <- map["nameB"]
    }
}
