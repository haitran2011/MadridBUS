import Foundation
import ObjectMapper

final class BusNodesForBusLinesDTO: DTO {
    private var date: String = ""
    var lines: String = ""
    
    init(using lines: [String]) {
        super.init()
        date = Date.string(from: Date(), using: "dd/MM/yyyy")
        if lines.count > 0 {
            self.lines = lines.joined(separator: "|")
        }
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        date <- map["SelectDate"]
        lines <- map["Lines"]
    }
}
