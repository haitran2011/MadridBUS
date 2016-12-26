import Foundation

protocol WelcomePresenter {
    var availableBusLineTypes: [BusLineType] { get }
    
    func obtainBusLineTypes()
    func obtainBusCalendar()
    
    func config(using view: View)
}

class WelcomePresenterBase: Presenter, WelcomePresenter {
    private weak var view: WelcomeView!
    private var busLineTypes: BusLineTypesInteractor!
    private var busCalendar: BusCalendarInteractor!
    
    var availableBusLineTypes: [BusLineType] = []
    
    required init(injector: Injector) {
        busLineTypes = injector.instanceOf(BusLineTypesInteractor.self)
        busCalendar = injector.instanceOf(BusCalendarInteractor.self)
        super.init(injector: injector)
    }

    func config(using view: View) {
        guard let welcomeView = view as? WelcomeView else {
            fatalError("\(view) is not an WelcomeView")
        }
        
        self.view = welcomeView
        super.config(view: view)
    }
    
    func obtainBusLineTypes() {
        busLineTypes.subscribeHandleErrorDelegate(delegate: self)
        
        busLineTypes.execute { (busLineTypesArray) in
            self.availableBusLineTypes = busLineTypesArray
        }
    }
    
    func obtainBusCalendar() {
        busCalendar.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusCalendarDTO(from: Date(), to: Date.nextWeek())
        
        busCalendar.execute(dto) { (calendarItems) in
            
        }
    }
}
