import Foundation
import ObjectMapper
import Alamofire

class BusRequestBuilder: RequestBuilder {
    func buildForJsonResponseFor<T:Mappable>(_ responseType: T.Type) -> JsonRequest<T> {
        guard let endPoint = endPoint, let method = method else {
            fatalError("Missing enpoint or method in \(self)")
        }
        
        let url = remoteHost + endPoint
        return JsonRequest<T>(url: url, method: method, parameter: parameter, encoding: URLEncoding.httpBody)
    }
    
    func buildForStringResponse() -> StringRequest {
        guard let endPoint = endPoint, let method = method else {
            fatalError("Missing enpoind or method in \(self)")
        }
        
        let url = remoteHost + endPoint
        return StringRequest(url: url, method: method, parameter: parameter, encoding: URLEncoding.httpBody)
    }
}
