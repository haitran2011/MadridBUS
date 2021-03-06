import Foundation
import Alamofire
import ObjectMapper

class StringRequest: Request {
    typealias ResponseType = String
    
    var group: DispatchGroup = DispatchGroup()
    
    var stringURL: String
    var method: HTTPMethod
    var parameter: Mappable
    var encoding: ParameterEncoding?
    var response: Response<ResponseType>
    var skippableKey: String?
    
    required init(url: String, method: HTTPMethod, parameter: Mappable, encoding: ParameterEncoding?, skippableKey: String?) {
        self.stringURL = url
        self.method = method
        self.parameter = parameter
        self.response = Response<ResponseType>()
        self.encoding = encoding
        self.skippableKey = skippableKey
    }
    
    func addSuccessResponse(_ data: Data) {
        response.dataResponse = String(data: data, encoding: .utf8)
    }
}
