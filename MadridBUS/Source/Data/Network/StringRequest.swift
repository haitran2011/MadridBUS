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
    
    required init(url: String, method: HTTPMethod, parameter: Mappable, encoding: ParameterEncoding?) {
        self.stringURL = url
        self.method = method
        self.parameter = parameter
        self.response = Response<ResponseType>()
        self.encoding = encoding
    }
    
    func addSuccessResponse(_ data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            let jsonDictionary = (json as! NSDictionary)["resultValues"]
            let validData = try JSONSerialization.data(withJSONObject: jsonDictionary!, options: .prettyPrinted)
        
            response.dataResponse = String(data: validData, encoding: .utf8)
        } catch {
            response.dataResponse = ""
        }
    }
}
