import Foundation

protocol WelcomePresenter {
    var availableBusGroups: [BusGroup] { get }
    
    func obtainBusGroups()
    func obtainBusCalendar()
    func obtainBusLineBasicInfo(from lines: String...)
    func obtainBusNodeBasicInfo(from nodes: String...)
    func obtainBusNodes(from lines: String...)
    func obtainBusLinesSchedule(from lines: String...)
    func obtainBusLineTimeTable(from line: String)
    
    func obtainPOIList(latitude: Double, longitude: Double, radius: Int)
    func nodesAround(latitude: Double, longitude: Double, radius: Int)
    func nodeArrivals(using nodeId: String)
    
    func config(using view: View)
}

class WelcomePresenterBase: Presenter, WelcomePresenter {
    private weak var view: WelcomeView!
    private var busGroups: BusGroupsInteractor!
    private var busCalendar: BusCalendarInteractor!
    private var busLinesBasicInfo: BusLinesBasicInfoInteractor!
    private var busNodesBasicInfo: BusNodesBasicInfoInteractor!
    private var nodesForBusLines: BusNodesForBusLinesInteractor!
    private var busLinesSchedule: BusLinesScheduleInteractor!
    private var busLineTimeTable: BusLineTimeTableInteractor!
    
    private var poiList: BusGeoPOIInteractor!
    private var nodesAroundLocation: BusGeoNodesAroundLocationInteractor!
    private var nodeArrivals: BusGeoNodeArrivalsInteractor!
    
    var availableBusGroups: [BusGroup] = []
    
    required init(injector: Injector) {
        busGroups = injector.instanceOf(BusGroupsInteractor.self)
        busCalendar = injector.instanceOf(BusCalendarInteractor.self)
        busLinesBasicInfo = injector.instanceOf(BusLinesBasicInfoInteractor.self)
        busNodesBasicInfo = injector.instanceOf(BusNodesBasicInfoInteractor.self)
        nodesForBusLines = injector.instanceOf(BusNodesForBusLinesInteractor.self)
        busLinesSchedule = injector.instanceOf(BusLinesScheduleInteractor.self)
        busLineTimeTable = injector.instanceOf(BusLineTimeTableInteractor.self)
        poiList = injector.instanceOf(BusGeoPOIInteractor.self)
        nodesAroundLocation = injector.instanceOf(BusGeoNodesAroundLocationInteractor.self)
        nodeArrivals = injector.instanceOf(BusGeoNodeArrivalsInteractor.self)
        super.init(injector: injector)
    }

    func config(using view: View) {
        guard let welcomeView = view as? WelcomeView else {
            fatalError("\(view) is not an WelcomeView")
        }
        
        self.view = welcomeView
        super.config(view: view)
    }
    
    func obtainBusGroups() {
        busGroups.subscribeHandleErrorDelegate(delegate: self)
        
        busGroups.execute { (busGroups) in
            self.availableBusGroups = busGroups
        }
    }
    
    func obtainBusCalendar() {
        busCalendar.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusCalendarDTO(from: Date(), to: Date.nextWeek())
        
        busCalendar.execute(dto) { (calendarItems) in
            
        }
    }
    
    func obtainBusLineBasicInfo(from lines: String...) {
        busLinesBasicInfo.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusLinesBasicInfoDTO(using: lines)
        
        busLinesBasicInfo.execute(dto) { (busLines) in
            
        }
    }
    
    func obtainBusNodeBasicInfo(from nodes: String...) {
        busNodesBasicInfo.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusNodesBasicInfoDTO(using: nodes)
        
        busNodesBasicInfo.execute(dto) { (busNodes) in
            
        }
    }
    
    func obtainBusNodes(from lines: String...) {
        nodesForBusLines.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusNodesForBusLinesDTO(using: lines)
        
        nodesForBusLines.execute(dto) { (lineNodes) in
            
        }
    }
    
    func obtainBusLinesSchedule(from lines: String...) {
        busLinesSchedule.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusLinesScheduleDTO(using: lines)
        
        busLinesSchedule.execute(dto) { (linesSchedule) in
            
        }
    }
    
    func obtainBusLineTimeTable(from line: String) {
        busLineTimeTable.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusLineTimeTableDTO(using: line)
        
        busLineTimeTable.execute(dto) { (lineTimeTable) in
            
        }
    }
    
    func obtainPOIList(latitude: Double, longitude: Double, radius: Int) {
        poiList.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusGeoPOIDTO(latitude: latitude, longitude: longitude, radius: radius)
        
        poiList.execute(dto) { (poiList) in
            
        }
    }
    
    func nodesAround(latitude: Double, longitude: Double, radius: Int) {
        nodesAroundLocation.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusGeoNodesAroundLocationDTO(latitude: latitude, longitude: longitude, radius: radius)
        
        nodesAroundLocation.execute(dto) { (nodesList) in
            
        }
    }
    
    func nodeArrivals(using nodeId: String) {
        nodeArrivals.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusGeoNodeArrivalsDTO(nodeId: nodeId)
        
        nodeArrivals.execute(dto) { (arrivalsList) in
            
        }
    }
}
