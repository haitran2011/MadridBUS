import Foundation
import ObjectMapper

class BusLineBasicSchedule: Mappable {
    var line: String = ""
    var headerStartTime: Date = Date()
    var headerEndTime: Date = Date()
    var terminusStartTime: Date = Date()
    var terminusEndTime: Date = Date()
    var dayType: BusDayType = .undefined
    
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm:ss"
        
        line <- map["line"]
        headerStartTime <- (map["timeFirstA"], DateFormatterTransform(dateFormatter: dateFormatter))
        headerEndTime <- (map["timeEndA"], DateFormatterTransform(dateFormatter: dateFormatter))
        terminusStartTime <- (map["timeFirstB"], DateFormatterTransform(dateFormatter: dateFormatter))
        terminusEndTime <- (map["timeEndB"], DateFormatterTransform(dateFormatter: dateFormatter))
        dayType <- (map["typeDay"], EnumTransform<BusDayType>())
    }
}

final class BusLineSchedule: Mappable {
    var holidaySchedule: BusLineBasicSchedule?
    var labourSchedule: BusLineBasicSchedule?
    var saturdaySchedule: BusLineBasicSchedule?
    var fridaySchedule: BusLineBasicSchedule?
    
    init(using json: String) {
        let schedules: [BusLineBasicSchedule] = Mapper<BusLineBasicSchedule>().mapArray(JSONString: json)!

        for aSchedule in schedules {
            switch aSchedule.dayType {
            case .holiday: holidaySchedule = aSchedule
            case .labour: labourSchedule = aSchedule
            case .saturday: saturdaySchedule = aSchedule
            case .friday: fridaySchedule = aSchedule
            case .undefined: break
            }
        }
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        var schedules: [BusLineBasicSchedule] = []
        schedules <- map
        
        for aSchedule in schedules {
            switch aSchedule.dayType {
            case .holiday: holidaySchedule = aSchedule
            case .labour: labourSchedule = aSchedule
            case .saturday: saturdaySchedule = aSchedule
            case .friday: fridaySchedule = aSchedule
            case .undefined: break
            }
        }
    }
}
