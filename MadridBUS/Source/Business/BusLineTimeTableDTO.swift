import Foundation
import ObjectMapper

final class BusLineTimeTableDTO: DTO {
    private var date: String = ""
    var line: String = ""
    
    init(using line: String) {
        super.init()
        date = Date.string(from: Date(), using: "dd/MM/yyyy")
        self.line = line
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        date <- map["SelectDate"]
        line <- map["Lines"]
    }
}
