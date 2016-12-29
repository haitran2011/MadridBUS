import Foundation

protocol NodesNearTableCellPresenter {
    func nextArrival(at line: String, on node: String)
    func config(using cell: NodesNearTableCell)
}

class NodesNearTableCellPresenterBase: NodesNearTableCellPresenter, HandleErrorDelegate {
    private weak var cell: NodesNearTableCell!
    private var nodeArrivals: BusGeoNodeArrivalsInteractor!
    
    required init(injector: Injector = SwinjectInjectorProvider.injector) {
        nodeArrivals = injector.instanceOf(BusGeoNodeArrivalsInteractor.self)
    }
    
    func config(using cell: NodesNearTableCell) {
        self.cell = cell
    }
    
    func handleErrors(error: Error) {
        
    }
    
    internal func nextArrival(at line: String, on node: String) {
        nodeArrivals.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusGeoNodeArrivalsDTO(nodeId: node)
        
        nodeArrivals.execute(dto) { (arrivalsList) in
            if let firstToArrive = arrivalsList.first {
                self.cell.update(using: firstToArrive.ETA, heading: firstToArrive.destination)
            } else {
                self.cell.update(using: 0, heading: "ERROR")
            }
        }
    }
}
