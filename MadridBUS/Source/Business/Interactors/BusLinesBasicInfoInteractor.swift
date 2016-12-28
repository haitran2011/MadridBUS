import Foundation

protocol BusLinesBasicInfoInteractor: Interactor {
    func execute(_ dto: BusLinesBasicInfoDTO, success: @escaping ([BusLineBasicInfo]) -> ())
}

class BusLinesBasicInfoAsyncInteractor: AsyncInteractor<BusLinesBasicInfoDTO, [BusLineBasicInfo]>, BusLinesBasicInfoInteractor {
    let busRepository: BusRepository
    
    init(injector: Injector) {
        busRepository = injector.instanceOf(BusRepository.self)
    }
    
    func execute(_ dto: BusLinesBasicInfoDTO, success: @escaping ([BusLineBasicInfo]) -> ()) {
        super.execute(params: dto, success: success)
    }
    
    override func runInBackground(params: [BusLinesBasicInfoDTO]) throws -> [BusLineBasicInfo] {
        return try busRepository.lineBasicInfo(dto: params[0])
    }
}
