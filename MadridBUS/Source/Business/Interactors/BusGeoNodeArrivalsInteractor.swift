import Foundation

protocol BusGeoNodeArrivalsInteractor: Interactor {
    func execute(_ dto: BusGeoNodeArrivalsDTO, success: @escaping ([BusGeoNodeArrival]) -> ())
}

class BusGeoNodeArrivalsAsyncInteractor: AsyncInteractor<BusGeoNodeArrivalsDTO, [BusGeoNodeArrival]>, BusGeoNodeArrivalsInteractor {
    let busGeoRepository: BusGeoRepository
    
    init(injector: Injector) {
        busGeoRepository = injector.instanceOf(BusGeoRepository.self)
    }
    
    internal func execute(_ dto: BusGeoNodeArrivalsDTO, success: @escaping ([BusGeoNodeArrival]) -> ()) {
        super.execute(params: dto, success: success)
    }
    
    override func runInBackground(params: [BusGeoNodeArrivalsDTO]) throws -> [BusGeoNodeArrival] {
        return try busGeoRepository.nodeArrivals(dto: params[0])
    }
}
