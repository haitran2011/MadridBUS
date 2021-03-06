import Foundation

protocol BusRepository {
    func groups() throws -> [BusGroup]
    func calendar(dto: BusCalendarDTO) throws -> [BusCalendarItem]
    
    func lineBasicInfo(dto: BusLinesBasicInfoDTO) throws -> [BusLineBasicInfo]
    func nodeBasicInfo(dto: BusNodesBasicInfoDTO) throws -> [BusNodeBasicInfo]
    func nodesForBusLines(dto: BusNodesForBusLinesDTO) throws -> [BusNodeLocalized]
    func busLineSchedule(dto: BusLinesScheduleDTO)  throws -> BusLineSchedule
    func busLineTimeTable(dto: BusLineTimeTableDTO) throws -> [BusLineTimeTableItem]
}
