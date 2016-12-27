import Foundation

protocol BusRepository {
    func groups() throws -> [BusGroup]
    func calendar(dto: BusCalendarDTO) throws -> [BusCalendarItem]
    
    func lineBasicInfo(dto: BusLinesBasicInfoDTO) throws -> [BusLineBasicInfo]
    func nodeBasicInfo(dto: BusNodesBasicInfoDTO) throws -> [BusNodeBasicInfo]
    func nodesForBusLines(dto: BusNodesForBusLinesDTO) throws -> [BusNodeLocalized]
}
