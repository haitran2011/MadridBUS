import Foundation

protocol BusNodesBasicInfoInteractor: Interactor {
    func execute(_ dto: BusNodesBasicInfoDTO, success: @escaping ([BusNodeBasicInfo]) -> ())
}

class BusNodesBasicInfoAsyncInteractor: AsyncInteractor<BusNodesBasicInfoDTO, [BusNodeBasicInfo]>, BusNodesBasicInfoInteractor {
    let busRepository: BusRepository
    
    init(injector: Injector) {
        busRepository = injector.instanceOf(BusRepository.self)
    }
    
    func execute(_ dto: BusNodesBasicInfoDTO, success: @escaping ([BusNodeBasicInfo]) -> ()) {
        super.execute(success: success, params: dto)
    }
    
    override func runInBackground(params: [BusNodesBasicInfoDTO]) throws -> [BusNodeBasicInfo] {
        return try busRepository.nodeBasicInfo(dto: params[0])
    }
}
