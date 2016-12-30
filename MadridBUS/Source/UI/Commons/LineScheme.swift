import UIKit

struct LineSchemeTheme {
    var highlightedBackgroundColor = UIColor.gray
    var highlightedForegroundColor = UIColor.black
    var highlightedTitleColor = UIColor.white
    
    var normalBackgroundColor = UIColor.white
    var normalForegroundColor = UIColor.gray
    var normalTitleColor = UIColor.black
    
    var titleFont = UIFont.systemFont(ofSize: 13)
}

enum LineSchemeDirection {
    case forward
    case backwards
    case undefined
}

protocol LineSchemeDelegate {
    func didTap(node: LineSchemeNodeModel)
}

class LineScheme: UIControl {
    var delegate: LineSchemeDelegate?
    
    private var nodes: [LineSchemeNodeModel]
    private var direction: LineSchemeDirection
    private var graphicNodes: [LineSchemeGraphicNode] = []
    
    private var theme: LineSchemeTheme
    
    init(with nodes: [LineSchemeNodeModel], direction: LineSchemeDirection, theme: LineSchemeTheme) {
        self.nodes = nodes
        self.direction = direction
        self.theme = theme
        
        super.init(frame: .zero)
        self.tintColor = theme.normalForegroundColor
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        drawSchema()
    }
    
    private func drawSchema() {
        graphicNodes.forEach({ $0.removeFromSuperview() })
        graphicNodes.removeAll()
        
        var filteredNodes = nodes.filter { $0.direction == direction }
        filteredNodes = filteredNodes.sorted { $0.position < $1.position }
        
        for aNode in filteredNodes {
            var currentNode: LineSchemeGraphicNode
            if aNode == filteredNodes.first! {
                currentNode = LineSchemeNodeTop(with: aNode, dotRadius: 8, theme: theme)
            } else if aNode == filteredNodes.last! {
                currentNode = LineSchemeNodeBottom(with: aNode, dotRadius: 8, theme: theme)
            } else {
                currentNode = LineSchemeNodeMiddle(with: aNode, dotRadius: 8, theme: theme)
            }
            
            currentNode.nameLabel.font = theme.titleFont
            currentNode.nameLabel.textColor = theme.normalTitleColor
            currentNode.backgroundColor = theme.normalBackgroundColor
            currentNode.nameLabel.text = aNode.name
            currentNode.delegate = self
            
            graphicNodes.append(currentNode)
        }
        
        graphicNodes.forEach({ addSubview($0) })

        layoutIfNeeded()
    }
    
    func change(to newDirection: LineSchemeDirection) {
        guard direction != newDirection else {
            return
        }

        switch newDirection {
        case .forward, .backwards:
            direction = newDirection
            drawSchema()
        case .undefined: break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var i = 0
        for aGraphicNode in graphicNodes {
            aGraphicNode.frame = CGRect(x: bounds.minX, y: CGFloat(i * 50), width: bounds.maxX, height: 50.0)
            i = i + 1
        }
        
        var currentFrame = CGRect(origin: frame.origin, size: frame.size)
        currentFrame.origin = CGPoint(x: 0, y: 0)
        currentFrame.size = CGSize(width: bounds.maxX, height: CGFloat(i * 50))
        frame = currentFrame
        layoutIfNeeded()
    }
}

extension LineScheme: LineSchemeGraphicNodeDelegate {
    func didTap(node: LineSchemeGraphicNode) {
        for aNode in subviews {
            guard let currentNode = aNode as? LineSchemeGraphicNode else {
                continue
            }
            
            if currentNode != node {
                currentNode.reset()
            }
        }
        
        delegate?.didTap(node: node.node)
    }
}
