import Foundation
import ObjectMapper

final class Empty: Mappable {
    
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {}
    func toJSON() -> [String : Any] {return [:]}
}

