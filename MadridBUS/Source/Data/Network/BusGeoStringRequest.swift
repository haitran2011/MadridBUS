import Foundation
import Alamofire
import ObjectMapper

class BusGeoStringRequest: Request {
    typealias ResponseType = String
    
    var group: DispatchGroup = DispatchGroup()
    
    var stringURL: String
    var method: HTTPMethod
    var parameter: Mappable
    var encoding: ParameterEncoding?
    var response: Response<ResponseType>
    
    required init(url: String, method: HTTPMethod, parameter: Mappable, encoding: ParameterEncoding?) {
        self.stringURL = url
        self.method = method
        self.parameter = parameter
        self.response = Response<ResponseType>()
        self.encoding = encoding
    }
    
    func addSuccessResponse(_ data: Data) {
        response.dataResponse = String(data: data, encoding: .utf8)
    }
}
