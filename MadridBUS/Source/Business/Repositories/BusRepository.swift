import Foundation

protocol BusRepository {
    func lineTypes() throws -> [BusLineType]
}
