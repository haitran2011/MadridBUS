import Foundation

protocol BusLineTypesInteractor: Interactor {
    func execute(success: @escaping ([BusLineType]) -> ())
}

class BusLineTypesAsyncInteractor: AsyncInteractor<Void, [BusLineType]>, BusLineTypesInteractor {
    let busRepository: BusRepository
    
    init(injector: Injector) {
        busRepository = injector.instanceOf(BusRepository.self)
    }
    
    internal func execute(success: @escaping ([BusLineType]) -> ()) {
        super.execute(success: success)
    }
    
    override func runInBackground(params: [Void]) throws -> [BusLineType] {
        return try busRepository.lineTypes()
    }
}
