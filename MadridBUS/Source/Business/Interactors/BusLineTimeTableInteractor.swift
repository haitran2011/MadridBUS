import Foundation

protocol BusLineTimeTableInteractor: Interactor {
    func execute(_ dto: BusLineTimeTableDTO, success: @escaping ([BusLineTimeTableItem]) -> ())
}

class BusLineTimeTableAsyncInteractor: AsyncInteractor<BusLineTimeTableDTO, [BusLineTimeTableItem]>, BusLineTimeTableInteractor {
    let busRepository: BusRepository
    
    init(injector: Injector) {
        busRepository = injector.instanceOf(BusRepository.self)
    }
    
    func execute(_ dto: BusLineTimeTableDTO, success: @escaping ([BusLineTimeTableItem]) -> ()) {
        super.execute(success: success, params: dto)
    }
    
    override func runInBackground(params: [BusLineTimeTableDTO]) throws -> [BusLineTimeTableItem] {
        return try busRepository.busLineTimeTable(dto: params[0])
    }
}
