import Foundation
import ObjectMapper

class BusGeoRepositoryBase: Repository, BusGeoRepository {
    internal func poi(dto: BusGeoPOIDTO) throws -> [POI] {
        let request = RequestBuilder()
            .post()
            .url("/geo/GetPointsOfInterest.php")
            .skip(key: "poiList")
            .parameter(parameter: dto)
            .buildForJsonResponseFor(POI.self)
        
        requestClient.execute(request)
        
        return try processMultiResponse(response: request.response)
    }
    
    func busNodesAroundLocation(dto: BusGeoNodesAroundLocationDTO) throws -> [BusGeoNode] {
        let request = RequestBuilder()
            .post()
            .url("/geo/GetStopsFromXY.php")
            .skip(key: "stop")
            .parameter(parameter: dto)
            .buildForJsonResponseFor(BusGeoNode.self)
        
        requestClient.execute(request)
        
        return try processMultiResponse(response: request.response)
    }
}
