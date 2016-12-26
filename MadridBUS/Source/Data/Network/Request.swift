import Foundation
import Alamofire
import ObjectMapper

protocol Request: class {
    associatedtype ResponseType
    
    var group: DispatchGroup { get }
    var stringURL: String { get }
    var method: HTTPMethod { get }
    var parameter: Mappable { get }
    var encoding: ParameterEncoding? { get }
    var response: Response<ResponseType> { get }
    
    init(url: String, method: HTTPMethod, parameter: Mappable, encoding: ParameterEncoding?)
    
    func addSuccessResponse(_ data: Data)
}

extension Request {
    
    init(url: String, method: HTTPMethod, parameter: Mappable) {
        self.init(url: url, method: method, parameter: parameter, encoding: nil)
    }
    
    init(url: String, method: HTTPMethod) {
        self.init(url: url, method: method, parameter: Empty())
    }
    
    init(urlForGet: String, parameter: Mappable) {
        self.init(url: urlForGet, method: HTTPMethod.get, parameter: parameter)
    }
    
    init(urlForGet: String) {
        self.init(url: urlForGet, method: HTTPMethod.get)
    }
    
    func prepareRequest() {
        group.enter()
    }
    
    func handleResponse(serverResponse: DataResponse<Data>) {
        switch serverResponse.result {
        case .success(let data):
            addSuccessResponse(data)
        case .failure(let error):
            response.dataError = error as NSError
        }
        
        print(serverResponse.debugDescription)
        
        group.leave()
    }
    
    func waitForResult() {
        group.wait()
    }
}

class Response<T> {
    
    var dataResponse: T?
    var dataArrayResponse: [T]?
    var dataError: Error?
    
    var isSuccess: Bool {
        return dataError == nil
    }
    
}
