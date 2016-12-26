import Foundation

protocol BusCalendarInteractor: Interactor {
    func execute(_ dto: BusCalendarDTO, success: @escaping ([BusCalendarItem]) -> ())
}

class BusCalendarAsyncInteractor: AsyncInteractor<BusCalendarDTO, [BusCalendarItem]>, BusCalendarInteractor {
    let busRepository: BusRepository
    
    init(injector: Injector) {
        busRepository = injector.instanceOf(BusRepository.self)
    }
    
    func execute(_ dto: BusCalendarDTO, success: @escaping ([BusCalendarItem]) -> ()) {
        super.execute(success: success, params: dto)
    }

    override func runInBackground(params: [BusCalendarDTO]) throws -> [BusCalendarItem] {
        return try busRepository.calendar(dto: params[0])
    }
}
