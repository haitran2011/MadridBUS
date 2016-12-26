import Foundation

class BusRepositoryBase: Repository, BusRepository {
    func lineTypes() throws -> [BusLineType] {
        let request = RequestBuilder()
            .post()
            .url("/GetGroups.php")
            .parameter(parameter: DTO())
            .buildForJsonResponseFor(BusLineType.self)
        
        requestClient.execute(request)

        return try processMultiResponse(response: request.response)
    }
    
    func calendar(dto: BusCalendarDTO) throws -> [BusCalendarItem] {
        let request = RequestBuilder()
            .post()
            .url("/GetCalendar.php")
            .parameter(parameter: dto)
            .buildForJsonResponseFor(BusCalendarItem.self)
        
        requestClient.execute(request)
        
        return try processMultiResponse(response: request.response)
    }
}
