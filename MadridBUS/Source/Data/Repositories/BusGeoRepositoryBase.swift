import Foundation
import ObjectMapper

class BusGeoRepositoryBase: Repository, BusGeoRepository {
    internal func poi(dto: BusGeoPOIDTO) throws -> [POI] {
        let request = BusGeoRequestBuilder()
            .post()
            .url("/geo/GetPointsOfInterest.php")
            .parameter(parameter: dto)
            .buildForStringResponse()
        
        requestClient.execute(request)
        
        do {
            let jsonResponse = try processSingleResponse(response: request.response)
            let jsonData = try JSONSerialization.jsonObject(with: jsonResponse.data(using: .utf8)!, options: .allowFragments)
            let jsonDictionary = (jsonData as! NSDictionary)["poiList"]
            let json = try JSONSerialization.data(withJSONObject: jsonDictionary!, options: .prettyPrinted)
            
            return Mapper<POI>().mapArray(JSONString: String(bytes: json, encoding: .utf8)!)!
        } catch {
            return []
        }
    }
}
