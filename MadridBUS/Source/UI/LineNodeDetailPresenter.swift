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
            var i = 0
            for aNode in busNodes {
                var nodeModel: LineSchemeNodeModel
                
                if aNode.type == .nodeForward || aNode.type == .vertexForward {
                    nodeModel = LineSchemeNodeModel(name: aNode.name.capitalized, position: i, direction: .forward)
                } else if aNode.type == .nodeBackwards || aNode.type == .vertexBackwards {
                    nodeModel = LineSchemeNodeModel(name: aNode.name.capitalized, position: i, direction: .backwards)
                } else {
                    nodeModel = LineSchemeNodeModel(name: aNode.name.capitalized, position: i, direction: .undefined)
                }

                graphicNodes.append(nodeModel)
                i = i + 1
            }
            
            self.view.update(withNodes: graphicNodes)
        }
    }
}
