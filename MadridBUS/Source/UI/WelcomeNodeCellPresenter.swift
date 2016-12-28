import Foundation

protocol WelcomeNodeCellPresenter {
    func nextArrival(at line: String, on node: String)
    func config(using cell: WelcomeNodeCell)
}

class WelcomeNodeCellPresenterBase: WelcomeNodeCellPresenter, HandleErrorDelegate {
    private weak var cell: WelcomeNodeCell!
    private var nodeArrivals: BusGeoNodeArrivalsInteractor!
    
    required init(injector: Injector = SwinjectInjectorProvider.injector) {
        nodeArrivals = injector.instanceOf(BusGeoNodeArrivalsInteractor.self)

    }
    
    func config(using cell: WelcomeNodeCell) {
        self.cell = cell
    }
    
    func handleErrors(error: Error) {
        
    }
    
    internal func nextArrival(at line: String, on node: String) {
        nodeArrivals.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusGeoNodeArrivalsDTO(nodeId: node)
        
        nodeArrivals.execute(dto) { (arrivalsList) in
            let secondsETA = arrivalsList.first!.ETA
            
            self.cell.update(using: "\(secondsETA / 60) min.")
        }
    }
}
