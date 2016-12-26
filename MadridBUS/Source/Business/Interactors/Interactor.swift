import Foundation

protocol Interactor {
    func subscribeHandleErrorDelegate(delegate: HandleErrorDelegate)
}

protocol HandleErrorDelegate: class {
    func handleErrors(error: Error)
}

class AsyncInteractor<ParameterType, ResponseType>: Interactor {
    
    private var handleErrorDelegate: HandleErrorDelegate?
    
    func execute(success: @escaping (ResponseType) -> (), params: ParameterType...) {
        DispatchQueue.global(qos: .background).async {
            do {
                let result = try self.runInBackground(params: params)
                
                self.notifyResult(result: result, success: success)
            } catch Errors.RepositoryError(let error) {
                self.notifyError(error: error)
            } catch {
                
            }
        }
    }

    func runInBackground(params: [ParameterType]) throws -> ResponseType {
        fatalError("Method runInBackground must be overrided!!! in \(self)")
    }
    
    private func notifyResult(result: ResponseType, success: @escaping (ResponseType) -> ()) {
        DispatchQueue.main.async {
            success(result)
        }
    }
    
    func subscribeHandleErrorDelegate(delegate: HandleErrorDelegate) {
        handleErrorDelegate = delegate
    }
    
    private func notifyError(error: Error) {
        guard let delegate = handleErrorDelegate else {
            fatalError("HandleErrorDelegate has not set in \(self)")
        }
        
        DispatchQueue.main.async {
            delegate.handleErrors(error: error)
        }
    }
}
