import Foundation

protocol BusGeoPOIInteractor: Interactor {
    func execute(_ dto: BusGeoPOIDTO, success: @escaping ([POI]) -> ())
}

class BusGeoPOIAsyncInteractor: AsyncInteractor<BusGeoPOIDTO, [POI]>, BusGeoPOIInteractor {
    let busGeoRepository: BusGeoRepository
    
    init(injector: Injector) {
        busGeoRepository = injector.instanceOf(BusGeoRepository.self)
    }
    
    internal func execute(_ dto: BusGeoPOIDTO, success: @escaping ([POI]) -> ()) {
        super.execute(success: success, params: dto)
    }
    
    override func runInBackground(params: [BusGeoPOIDTO]) throws -> [POI] {
        return try busGeoRepository.poi(dto: params[0])
    }
}
