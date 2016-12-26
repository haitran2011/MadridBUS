import Foundation
import ObjectMapper

final class BusCalendarDTO: DTO {
    var from: String = ""
    var to: String = ""
    
    init(from fromDate: Date, to toDate: Date) {
        super.init()
        from = Date.string(from: fromDate, using: "dd/MM/yyyy")
        to = Date.string(from: toDate, using: "dd/MM/yyyy")
    }

    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        from <- map["SelectDateBegin"]
        to <- map["SelectDateEnd"]
    }
}
