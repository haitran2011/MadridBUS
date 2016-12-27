import Foundation
import ObjectMapper

final class BusNodesBasicInfoDTO: DTO {
    var nodes: String = ""
    
    init(using nodes: [String]) {
        super.init()
        if nodes.count > 0 {
            self.nodes = nodes.joined(separator: "|")
        }
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nodes <- map["Nodes"]
    }
}
