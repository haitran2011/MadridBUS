import Foundation

protocol WelcomePresenter {
    var availableBusGroups: [BusGroup] { get }
    
    func obtainBusGroups()
    func obtainBusCalendar()
    func obtainBusLineBasicInfo(from lines: String...)
    
    func config(using view: View)
}

class WelcomePresenterBase: Presenter, WelcomePresenter {
    private weak var view: WelcomeView!
    private var busGroups: BusGroupsInteractor!
    private var busCalendar: BusCalendarInteractor!
    private var busLinesBasicInfo: BusLinesBasicInfoInteractor!
    
    var availableBusGroups: [BusGroup] = []
    
    required init(injector: Injector) {
        busGroups = injector.instanceOf(BusGroupsInteractor.self)
        busCalendar = injector.instanceOf(BusCalendarInteractor.self)
        busLinesBasicInfo = injector.instanceOf(BusLinesBasicInfoInteractor.self)
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
}
