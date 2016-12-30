import Foundation
import Alamofire
import ObjectMapper

class JsonRequest<ResponseType:Mappable>: Request {
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
        guard data.count > 0 else {
            return
        }
        
        do {
            var json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let key = skippableKey {
                if let jsonFromKey = (json as? NSDictionary)?[key] {
                    json = jsonFromKey
                } else {
                    response.dataError = RepositoryError(message: "Empty data", code: 101)
                }
            }
            
            if let dataArrayResponse = Mapper<ResponseType>().mapArray(JSONObject: json) {
                response.dataArrayResponse = dataArrayResponse
            } else if let dataResponse = Mapper<ResponseType>().map(JSONObject: json) {
                response.dataResponse = dataResponse
            } else {
                response.dataError = RepositoryError(message: "Can't map json to type \(ResponseType.self)")
            }
        } catch {
            response.dataError = RepositoryError(message: "Error deserialized data to json")
        }
    }
}
