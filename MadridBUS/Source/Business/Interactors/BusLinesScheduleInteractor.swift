import Foundation

protocol BusLinesScheduleInteractor: Interactor {
    func execute(_ dto: BusLinesScheduleDTO, success: @escaping (BusLineSchedule) -> ())
}

class BusLineScheduleAsyncInteractor: AsyncInteractor<BusLinesScheduleDTO, BusLineSchedule>, BusLinesScheduleInteractor {
    let busRepository: BusRepository
    
    init(injector: Injector) {
        busRepository = injector.instanceOf(BusRepository.self)
    }
    
    func execute(_ dto: BusLinesScheduleDTO, success: @escaping (BusLineSchedule) -> ()) {
        super.execute(params: dto, success: success)
    }
    
    override func runInBackground(params: [BusLinesScheduleDTO]) throws -> BusLineSchedule {
        return try busRepository.busLineSchedule(dto: params[0])
    }
}
