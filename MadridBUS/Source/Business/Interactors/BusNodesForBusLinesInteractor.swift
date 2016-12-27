import Foundation

protocol BusNodesForBusLinesInteractor: Interactor {
    func execute(_ dto: BusNodesForBusLinesDTO, success: @escaping ([BusNodeLocalized]) -> ())
}

class BusNodesForBusLinesAsyncInteractor: AsyncInteractor<BusNodesForBusLinesDTO, [BusNodeLocalized]>, BusNodesForBusLinesInteractor {
    let busRepository: BusRepository
    
    init(injector: Injector) {
        busRepository = injector.instanceOf(BusRepository.self)
    }
    
    func execute(_ dto: BusNodesForBusLinesDTO, success: @escaping ([BusNodeLocalized]) -> ()) {
        super.execute(success: success, params: dto)
    }
    
    override func runInBackground(params: [BusNodesForBusLinesDTO]) throws -> [BusNodeLocalized] {
        return try busRepository.nodesForBusLines(dto: params[0])
    }
}
