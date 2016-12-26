import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

protocol RequestClient {
    func setAccessToken(token: String)
    func execute<R:Request>(_ request: R)
}

class AlamofireRequestClient: RequestClient {
    
    private static var accessToken: String = ""
    
    func setAccessToken(token: String) {
        AlamofireRequestClient.accessToken = token
    }
    
    func execute<R:Request>(_ request: R) {
        
        let params = request.parameter.toJSON()
        let encoding = selectEncoding(request)
        let headers = buildHeaders()
        
        request.prepareRequest()
        Alamofire
            .request(request.stringURL, method: request.method, parameters: params, encoding: encoding, headers: headers)
            .validate()
            .responseData(completionHandler: request.handleResponse)
        
        request.waitForResult()
    }
    
    private func selectEncoding<R:Request>(_ request: R) -> ParameterEncoding {
        if let encoding = request.encoding {
            return encoding
        }
        
        switch request.method {
        case .post:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    private func buildHeaders() -> [String: String] {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
}
