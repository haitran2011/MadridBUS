import Foundation
import ObjectMapper
import Alamofire

class BusGeoRequestBuilder: RequestBuilder {
    func buildForJsonResponseFor<T:Mappable>(_ responseType: T.Type) -> BusGeoJsonRequest<T> {
        guard let endPoint = endPoint, let method = method else {
            fatalError("Missing enpoint or method in \(self)")
        }
        
        let url = remoteHost + endPoint
        return BusGeoJsonRequest<T>(url: url, method: method, parameter: parameter, encoding: URLEncoding.httpBody)
    }
    
    func buildForStringResponse() -> BusGeoStringRequest {
        guard let endPoint = endPoint, let method = method else {
            fatalError("Missing enpoind or method in \(self)")
        }
        
        let url = remoteHost + endPoint
        return BusGeoStringRequest(url: url, method: method, parameter: parameter, encoding: URLEncoding.httpBody)
    }
}
