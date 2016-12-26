import Foundation

class BusRepositoryBase: Repository, BusRepository {
    
    func lineTypes() throws -> [BusLineType] {
        let request = RequestBuilder()
            .post()
            .url("/GetGroups.php")
            .parameter(parameter: RequestCredentials())
            .buildForJsonResponseFor(BusLineType.self)
        
        requestClient.execute(request)

        return try processMultiResponse(response: request.response)
    }
}
