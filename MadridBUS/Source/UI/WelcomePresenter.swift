import Foundation

protocol WelcomePresenter {
    func obtainLocation()
    func config(using view: View)
}

class WelcomePresenterBase: Presenter, WelcomePresenter {
    private weak var view: WelcomeView!

    private var nodesAroundLocation: BusGeoNodesAroundLocationInteractor!
    private var locationHelper: LocationHelper!
    
    internal var nearBusGeoNodes: [BusGeoNode] = [] {
        didSet {
            view.updateMap(with: nearBusGeoNodes)
        }
    }

    required init(injector: Injector) {
        nodesAroundLocation = injector.instanceOf(BusGeoNodesAroundLocationInteractor.self)
        locationHelper = injector.instanceOf(LocationHelper.self)
        super.init(injector: injector)
    }

    func config(using view: View) {
        guard let welcomeView = view as? WelcomeView else {
            fatalError("\(view) is not an WelcomeView")
        }
        
        self.view = welcomeView
        super.config(view: view)
    }
    
    override func handleErrors(error: Error) {
        if error._code == 101 {
            view.enable(mode: .zeroNodesAround)
        }
    }

    func obtainLocation() {
        if locationHelper.isLocationAvailable {
            locationHelper.acquireLocation { (acquiredLocation) in
                self.view.updateMap(with: acquiredLocation)
                //self.nodesAround(latitude: acquiredLocation.coordinate.latitude, longitude: acquiredLocation.coordinate.longitude, radius: 150)
                self.nodesAround(latitude: 40.382797016999334, longitude: -3.7231069600644706, radius: 200)
            }
        }
    }
    
    private func nodesAround(latitude: Double, longitude: Double, radius: Int) {
        nodesAroundLocation.subscribeHandleErrorDelegate(delegate: self)

        let dto = BusGeoNodesAroundLocationDTO(latitude: latitude, longitude: longitude, radius: radius)
        
        nodesAroundLocation.execute(dto) { (nodesList) in
            self.nearBusGeoNodes = nodesList
        }
    }
}
