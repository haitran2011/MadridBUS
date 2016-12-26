import Foundation
import ObjectMapper
import Alamofire

class RequestBuilder {
    private let remoteHost = "https://openbus.emtmadrid.es:9443/emt-proxy-server/last"
    
    private var endPoint: String?
    private var parameter: Mappable = Empty()
    private var method: HTTPMethod?
    
    func url(_ partialUrl: String) -> Self {
        self.endPoint = "/bus" + partialUrl
        return self
    }
    
    func httpMethod(_ method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    func post() -> Self {
        return httpMethod(.post)
    }
    
    func get() -> Self {
        return httpMethod(.get)
    }
    
    func parameter(parameter: Mappable) -> Self {
        self.parameter = parameter
        return self
    }

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
