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
                let secondsETA = firstToArrive.ETA
                
                var stringETA = ""
                if secondsETA < 60 {
                    stringETA = LocalizedLiteral.localize(using: "WELCOMENODECELL_LB_ETA")
                } else if secondsETA >= 9999 {
                    stringETA = "+ 20 min."
                } else {
                    stringETA = "\(secondsETA / 60) min."
                }
                
                self.cell.update(using: stringETA, heading: LocalizedLiteral.localize(using: "WELCOMENODECELL_LB_DIRECTION", with: firstToArrive.destination))
            } else {
                self.cell.update(using: "ERROR", heading: LocalizedLiteral.localize(using: "WELCOMENODECELL_LB_DIRECTION", with: "ERROR"))
            }
        }
    }
}
