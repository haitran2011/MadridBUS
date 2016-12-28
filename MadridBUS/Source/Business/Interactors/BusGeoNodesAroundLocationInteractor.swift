import Foundation

protocol BusGeoNodesAroundLocationInteractor: Interactor {
    func execute(_ dto: BusGeoNodesAroundLocationDTO, success: @escaping ([BusGeoNode]) -> (), error: @escaping (Error) -> ())
}

class BusGeoNodesAroundLocationAsyncInteractor: AsyncInteractor<BusGeoNodesAroundLocationDTO, [BusGeoNode]>, BusGeoNodesAroundLocationInteractor {
    let busGeoRepository: BusGeoRepository
    
    init(injector: Injector) {
        busGeoRepository = injector.instanceOf(BusGeoRepository.self)
    }
    
    internal func execute(_ dto: BusGeoNodesAroundLocationDTO, success: @escaping ([BusGeoNode]) -> (), error: @escaping (Error) -> ()) {
        super.execute(params: dto, success: success, error: error)
    }
    
    override func runInBackground(params: [BusGeoNodesAroundLocationDTO]) throws -> [BusGeoNode] {
        return try busGeoRepository.busNodesAroundLocation(dto: params[0])
    }
}
