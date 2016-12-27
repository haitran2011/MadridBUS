import Foundation

class BusRepositoryBase: Repository, BusRepository {
    func groups() throws -> [BusGroup] {
        let request = RequestBuilder()
            .post()
            .url("/bus/GetGroups.php")
            .parameter(parameter: DTO())
            .buildForJsonResponseFor(BusGroup.self)
        
        requestClient.execute(request)

        return try processMultiResponse(response: request.response)
    }
    
    func calendar(dto: BusCalendarDTO) throws -> [BusCalendarItem] {
        let request = RequestBuilder()
            .post()
            .url("/bus/GetCalendar.php")
            .parameter(parameter: dto)
            .buildForJsonResponseFor(BusCalendarItem.self)
        
        requestClient.execute(request)
        
        return try processMultiResponse(response: request.response)
    }

    internal func lineBasicInfo(dto: BusLinesBasicInfoDTO) throws -> [BusLineBasicInfo] {
        let request = RequestBuilder()
            .post()
            .url("/bus/GetListLines.php")
            .parameter(parameter: dto)
            .buildForJsonResponseFor(BusLineBasicInfo.self)
        
        requestClient.execute(request)
        
        do {
            let lines = try processMultiResponse(response: request.response)
            return lines
        } catch {
            let line = try processSingleResponse(response: request.response)
            return [line]
        }
    }

    internal func nodeBasicInfo(dto: BusNodesBasicInfoDTO) throws -> [BusNodeBasicInfo] {
        let request = RequestBuilder()
            .post()
            .url("/bus/GetNodesLines.php")
            .parameter(parameter: dto)
            .buildForJsonResponseFor(BusNodeBasicInfo.self)
        
        requestClient.execute(request)
        
        do {
            let nodes = try processMultiResponse(response: request.response)
            return nodes
        } catch {
            let node = try processSingleResponse(response: request.response)
            return [node]
        }
    }
}
