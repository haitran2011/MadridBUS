import Foundation
import ObjectMapper

enum Language: String {
    case spanish = "ES"
    case english = "EN"
    case undetermined = ""
}

class DTO: Mappable {
    var apiUser: String = "WEB.SERV.jorge.ramos@me.com"
    var apiKey: String = "0B56B4AF-3732-4198-9994-834A515970A5"
    
    init() {}
    required init?(map: Map) {}
    func mapping(map: Map) {
        apiUser <- map["idClient"]
        apiKey <- map["passKey"]
    }
}
