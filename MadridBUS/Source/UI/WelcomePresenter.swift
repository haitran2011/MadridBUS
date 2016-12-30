import Foundation

protocol WelcomePresenter {
    func nodesAround(using radius: Int)
    func nodes(on line: BusGeoLine, from node: BusGeoNode)
    func config(using view: View)
}

class WelcomePresenterBase: Presenter, WelcomePresenter {
    private weak var view: WelcomeView!

    private var nodesAroundLocation: BusGeoNodesAroundLocationInteractor!
    private var busNodesForLine: BusNodesForBusLinesInteractor!
    private var locationHelper: LocationHelper!

    required init(injector: Injector) {
        nodesAroundLocation = injector.instanceOf(BusGeoNodesAroundLocationInteractor.self)
        busNodesForLine = injector.instanceOf(BusNodesForBusLinesInteractor.self)
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

    func nodesAround(using radius: Int) {
        if locationHelper.isLocationAvailable {
            locationHelper.acquireLocation { (acquiredLocation) in
                self.view.updateMap(with: acquiredLocation)
                //self.nodesAround(latitude: acquiredLocation.coordinate.latitude, longitude: acquiredLocation.coordinate.longitude, radius: radius)
                self.nodesAround(latitude: 40.4668966, longitude: -3.6891933, radius: radius)
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
    
    func nodes(on line: BusGeoLine, from node: BusGeoNode) {
        busNodesForLine.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusNodesForBusLinesDTO(using: [line.id])
        
        busNodesForLine.execute(dto) { (lineNodes) in
            let detailViewController = LineNodeDetailViewBase(with: line, from: node, with: lineNodes)
            self.wireframe.pushTo(view: detailViewController)
        }
    }
}
