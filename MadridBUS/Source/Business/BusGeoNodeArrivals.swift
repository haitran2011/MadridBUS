import Foundation
import ObjectMapper

final class BusGeoNodeArrivalsDTO: DTO {
    var nodeId: String = ""
    var language: String = ""
    
    init(nodeId: String, language: Language = .spanish) {
        super.init()
        self.nodeId = nodeId
        self.language = language.rawValue
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nodeId <- map["idStop"]
        language <- map["cultureInfo"]
    }
}
