import Foundation

protocol BusGroupsInteractor: Interactor {
    func execute(success: @escaping ([BusGroup]) -> ())
}

class BusGroupsAsyncInteractor: AsyncInteractor<Void, [BusGroup]>, BusGroupsInteractor {
    let busRepository: BusRepository
    
    init(injector: Injector) {
        busRepository = injector.instanceOf(BusRepository.self)
    }
    
    internal func execute(success: @escaping ([BusGroup]) -> ()) {
        super.execute(success: success)
    }
    
    override func runInBackground(params: [Void]) throws -> [BusGroup] {
        return try busRepository.groups()
    }
}
