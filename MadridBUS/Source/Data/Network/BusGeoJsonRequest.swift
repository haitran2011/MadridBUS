import Foundation
import Alamofire
import ObjectMapper

class BusGeoJsonRequest<ResponseType:Mappable>: Request {
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
        guard data.count > 0 else {
            return
        }
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
 
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
