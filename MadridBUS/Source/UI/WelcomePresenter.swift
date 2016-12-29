import Foundation

protocol WelcomePresenter {
    func obtainLocation(using radius: Int)
    func config(using view: View)
}

class WelcomePresenterBase: Presenter, WelcomePresenter {
    private weak var view: WelcomeView!

    private var nodesAroundLocation: BusGeoNodesAroundLocationInteractor!
    private var locationHelper: LocationHelper!

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

    func obtainLocation(using radius: Int) {
        if locationHelper.isLocationAvailable {
            locationHelper.acquireLocation { (acquiredLocation) in
                self.view.updateMap(with: acquiredLocation)
                self.nodesAround(latitude: acquiredLocation.coordinate.latitude, longitude: acquiredLocation.coordinate.longitude, radius: radius)
            }
        }
    }
    
    private func nodesAround(latitude: Double, longitude: Double, radius: Int) {
        nodesAroundLocation.subscribeHandleErrorDelegate(delegate: self)

        let dto = BusGeoNodesAroundLocationDTO(latitude: latitude, longitude: longitude, radius: radius)
        
        nodesAroundLocation.execute(dto) { (nodesList) in
            self.view.nodesTableDataSet = nodesList
        }
    }
}
