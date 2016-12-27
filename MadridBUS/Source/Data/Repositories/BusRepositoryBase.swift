import Foundation
import ObjectMapper

class BusRepositoryBase: Repository, BusRepository {
    func groups() throws -> [BusGroup] {
        let request = RequestBuilder()
            .post()
            .url("/bus/GetGroups.php")
            .skip(key: "resultValues")
            .parameter(parameter: DTO())
            .buildForJsonResponseFor(BusGroup.self)
        
        requestClient.execute(request)

        return try processMultiResponse(response: request.response)
    }
    
    func calendar(dto: BusCalendarDTO) throws -> [BusCalendarItem] {
        let request = RequestBuilder()
            .post()
            .url("/bus/GetCalendar.php")
            .skip(key: "resultValues")
            .parameter(parameter: dto)
            .buildForJsonResponseFor(BusCalendarItem.self)
        
        requestClient.execute(request)
        
        return try processMultiResponse(response: request.response)
    }

    internal func lineBasicInfo(dto: BusLinesBasicInfoDTO) throws -> [BusLineBasicInfo] {
        let request = RequestBuilder()
            .post()
            .url("/bus/GetListLines.php")
            .skip(key: "resultValues")
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
            .skip(key: "resultValues")
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

    internal func nodesForBusLines(dto: BusNodesForBusLinesDTO) throws -> [BusNodeLocalized] {
        let request = RequestBuilder()
            .post()
            .url("/bus/GetRouteLines.php")
            .skip(key: "resultValues")
            .parameter(parameter: dto)
            .buildForJsonResponseFor(BusNodeLocalized.self)
        
        requestClient.execute(request)
        
        return try processMultiResponse(response: request.response)
    }
    
    internal func busLineSchedule(dto: BusLinesScheduleDTO) throws -> BusLineSchedule {
        let request = RequestBuilder()
            .post()
            .url("/bus/GetTimesLines.php")
            .skip(key: "resultValues")
            .parameter(parameter: dto)
            .buildForStringResponse()
        
        requestClient.execute(request)
        
        let jsonString = try processSingleResponse(response: request.response)

        return BusLineSchedule(using: jsonString) 
    }
    
    internal func busLineTimeTable(dto: BusLineTimeTableDTO) throws -> [BusLineTimeTableItem] {
        let request = RequestBuilder()
            .post()
            .url("/bus/GetTimeTableLines.php")
            .skip(key: "resultValues")
            .parameter(parameter: dto)
            .buildForJsonResponseFor(BusLineTimeTableItem.self)
        
        requestClient.execute(request)
        
        return try processMultiResponse(response: request.response)
    }
}
