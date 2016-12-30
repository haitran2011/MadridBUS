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
        if error._code == 1 {
            self.cell.update(using: nil, heading: "Sin servicio hasta las \(Date.string(from: cell.line!.startTime, using: "hh:mm a"))")
        }
    }
    
    internal func nextArrival(at line: String, on node: String) {
        nodeArrivals.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusGeoNodeArrivalsDTO(nodeId: node)
        
        nodeArrivals.execute(dto) { (arrivalsList) in
            if let firstToArrive = arrivalsList.first {
                self.cell.update(using: firstToArrive.ETA, heading: firstToArrive.destination)
            } else {
                self.cell.update(using: nil, heading: "ERROR")
            }
        }
    }
}
