import Foundation

protocol BusRepository {
    func groups() throws -> [BusGroup]
    func calendar(dto: BusCalendarDTO) throws -> [BusCalendarItem]
    
    func lineBasicInfo(dto: BusLinesBasicInfoDTO) throws -> [BusLineBasicInfo]
}
