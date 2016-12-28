import Foundation

protocol BusGeoRepository {
    func poi(dto: BusGeoPOIDTO) throws -> [POI]
    func busNodesAroundLocation(dto: BusGeoNodesAroundLocationDTO) throws -> [BusGeoNode]
    func nodeArrivals(dto: BusGeoNodeArrivalsDTO) throws -> [BusGeoNodeArrival]
}
