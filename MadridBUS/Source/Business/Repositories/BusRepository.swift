import Foundation

protocol BusRepository {
    func lineTypes() throws -> [BusLineType]
    func calendar(dto: BusCalendarDTO) throws -> [BusCalendarItem]
}
