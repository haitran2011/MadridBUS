import Foundation

protocol LineNodeDetailPresenter {
    func nodes(on line: String)
    
    func config(using view: View)
}

class LineNodeDetailPresenterBase: Presenter, LineNodeDetailPresenter {
    private weak var view: LineNodeDetailView!
    private var busNodesForLine: BusNodesForBusLinesInteractor!
    
    required init(injector: Injector) {
        busNodesForLine = injector.instanceOf(BusNodesForBusLinesInteractor.self)
        super.init(injector: injector)
    }
    
    func config(using view: View) {
        guard let lineNodeDetailView = view as? LineNodeDetailView else {
            fatalError("\(view) is not an LineNodeDetailView")
        }
        
        self.view = lineNodeDetailView
        super.config(view: view)
    }
    
    func nodes(on line: String) {
        busNodesForLine.subscribeHandleErrorDelegate(delegate: self)
        
        let dto = BusNodesForBusLinesDTO(using: [line])
        
        busNodesForLine.execute(dto) { (busNodes) in
            var graphicNodes: [LineSchemeNodeModel] = []
            for aNode in busNodes {
                let position = busNodes.index(of: aNode)!
                var nodeModel: LineSchemeNodeModel
                
                if aNode.type == .nodeForward || aNode.type == .vertexForward {
                    nodeModel = LineSchemeNodeModel(name: aNode.name.capitalized, position: position, direction: .forward)
                } else if aNode.type == .nodeBackwards || aNode.type == .vertexBackwards {
                    nodeModel = LineSchemeNodeModel(name: aNode.name.capitalized, position: position, direction: .backwards)
                } else {
                    nodeModel = LineSchemeNodeModel(name: aNode.name.capitalized, position: position, direction: .undefined)
                }

                graphicNodes.append(nodeModel)
            }
            
            self.view.update(withNodes: graphicNodes)
        }
    }
}
