import Foundation

class Repository {
    let requestClient: RequestClient

    required init(injector: Injector) {
        self.requestClient = injector.instanceOf(RequestClient.self)
    }

    func processSingleResponse<T>(response: Response<T>, functionName: String = #function) throws -> T {
        guard response.isSuccess else {
            throw Errors.RepositoryError(error: response.dataError!)
        }
        
        guard let singleData = response.dataResponse else {
            throw Errors.RepositoryError(error: buildUnexpectedError(functionName: functionName))
        }
        
        return singleData
    }
    
    func processOptionalResponse<T>(response: Response<T>, functionName: String = #function) throws -> T? {
        guard response.isSuccess else {
            throw Errors.RepositoryError(error: response.dataError!)
        }

        return response.dataResponse
    }
    
    func processMultiResponse<T>(response: Response<T>, functionName: String = #function) throws -> [T] {
        guard response.isSuccess else {
            throw Errors.RepositoryError(error: response.dataError!)
        }
        
        guard let multiData = response.dataArrayResponse else {
            throw Errors.RepositoryError(error: buildUnexpectedError(functionName: functionName))
        }
        
        return multiData
    }
    
    func processEmptyResponse<T>(response: Response<T>, functionName: String = #function) throws {
        guard response.isSuccess else {
            throw Errors.RepositoryError(error: response.dataError!)
        }
    }
    
    private func buildUnexpectedError(functionName: String) -> RepositoryError {
        return RepositoryError(message: "Unexpected data response in \(functionName)")
    }
    
}
