import Foundation

protocol BusGeoNodesAroundLocationInteractor: Interactor {
    func execute(_ dto: BusGeoNodesAroundLocationDTO, success: @escaping ([BusGeoNode]) -> ())
}

class BusGeoNodesAroundLocationAsyncInteractor: AsyncInteractor<BusGeoNodesAroundLocationDTO, [BusGeoNode]>, BusGeoNodesAroundLocationInteractor {
    let busGeoRepository: BusGeoRepository
    
    init(injector: Injector) {
        busGeoRepository = injector.instanceOf(BusGeoRepository.self)
    }
    
    internal func execute(_ dto: BusGeoNodesAroundLocationDTO, success: @escaping ([BusGeoNode]) -> ()) {
        super.execute(success: success, params: dto)
    }
    
    override func runInBackground(params: [BusGeoNodesAroundLocationDTO]) throws -> [BusGeoNode] {
        return try busGeoRepository.busNodesAroundLocation(dto: params[0])
    }
}
