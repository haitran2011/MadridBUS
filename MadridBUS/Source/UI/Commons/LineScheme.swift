import UIKit

struct LineSchemeTheme {
    var highlightedBackgroundColor: UIColor = UIColor.gray
    var highlightedForegroundColor: UIColor = UIColor.black
    var highlightedTitleColor: UIColor = UIColor.white
    var highlightedTitleFont: UIFont = UIFont.boldSystemFont(ofSize: 13)
    
    var normalBackgroundColor: UIColor = UIColor.white
    var normalForegroundColor: UIColor = UIColor.gray
    var normalTitleColor: UIColor = UIColor.black
    var normalTitleFont: UIFont = UIFont.systemFont(ofSize: 13)
    
    var orientation: LineSchemeOrientation = .horizontal
}

enum LineSchemeDirection {
    case forward
    case backwards
    case undefined
}

enum LineSchemeOrientation {
    case horizontal
    case vertical
}

protocol LineSchemeDelegate: class {
    func lineScheme(lineScheme: LineScheme, didFinishLoadingWith nodes: [LineSchemeNodeModel])
    func didTap(node: LineSchemeNodeModel)
}

@IBDesignable
class LineScheme: UIControl {
    weak var delegate: LineSchemeDelegate?
    
    private var nodes: [LineSchemeNodeModel]
    private var direction: LineSchemeDirection
    private var graphicNodes: [LineSchemeGraphicNode] = []
    private var scrollView = UIScrollView()
    internal var scrollContent = UIView()
    
    private var theme: LineSchemeTheme
    
    init(with nodes: [LineSchemeNodeModel], direction: LineSchemeDirection, theme: LineSchemeTheme = LineSchemeTheme(), delegate: LineSchemeDelegate? = nil) {
        self.nodes = nodes
        self.direction = direction
        self.theme = theme
        self.delegate = delegate
        
        super.init(frame: .zero)
        tintColor = theme.normalForegroundColor
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.nodes = []
        self.direction = .undefined
        self.theme = LineSchemeTheme()
        
        super.init(coder: aDecoder)
        tintColor = theme.normalForegroundColor
        addSubview(scrollView)
        commonInit()
    }
    
    private func commonInit() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        
        drawSchema()
    }
    
    func update(with nodes: [LineSchemeNodeModel], direction: LineSchemeDirection, theme: LineSchemeTheme = LineSchemeTheme(), delegate: LineSchemeDelegate? = nil) {
        self.nodes = nodes
        self.direction = direction
        self.theme = theme
        self.delegate = delegate
        tintColor = theme.normalForegroundColor
        
        drawSchema()
    }
    
    private func drawSchema() {
        if nodes.count > 0 {
            if let _ = scrollContent.superview { scrollContent.removeFromSuperview() }

            graphicNodes.forEach({ $0.removeFromSuperview() })
            graphicNodes.removeAll()

            var filteredNodes = nodes.filter { $0.direction == direction }
            filteredNodes = filteredNodes.sorted { $0.position < $1.position }
            
            var i = 0
            for aNode in filteredNodes {
                var currentNode: LineSchemeGraphicNode
                if aNode == filteredNodes.first! {
                    currentNode = LineSchemeNodeTop(with: aNode, dotRadius: 8, theme: theme)
                } else if aNode == filteredNodes.last! {
                    currentNode = LineSchemeNodeBottom(with: aNode, dotRadius: 8, theme: theme)
                } else {
                    currentNode = LineSchemeNodeMiddle(with: aNode, dotRadius: 8, theme: theme)
                }
                
                currentNode.nameLabel.font = theme.normalTitleFont
                currentNode.nameLabel.textColor = theme.normalTitleColor
                currentNode.backgroundColor = theme.normalBackgroundColor
                currentNode.nameLabel.text = aNode.name
                currentNode.delegate = self
                
                switch theme.orientation {
                case .vertical:
                    currentNode.frame = CGRect(x: 0, y: CGFloat(i * 50), width: bounds.maxX, height: 50.0)
                    
                case .horizontal:
                    currentNode.frame = CGRect(x: CGFloat(i * 100), y: 0, width: 100.0, height: bounds.maxY)
                }
                
                graphicNodes.append(currentNode)
                scrollContent.addSubview(currentNode)
                
                i = i + 1
            }
            
            switch theme.orientation {
            case .vertical:
                scrollContent.frame = CGRect(x: 0, y: 0, width: bounds.maxX, height: CGFloat(50 * i))
                scrollView.contentSize = CGSize(width: bounds.maxX, height: CGFloat(50 * i))
                
            case .horizontal:
                scrollContent.frame = CGRect(x: 0, y: 0, width: CGFloat(100 * i), height: bounds.maxY)
                scrollView.contentSize = CGSize(width: CGFloat(100 * i), height: bounds.maxY)
            }
            
            scrollView.addSubview(scrollContent)
            
            layoutIfNeeded()
            
            delegate?.lineScheme(lineScheme: self, didFinishLoadingWith: filteredNodes)
        }
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
}

extension LineScheme: LineSchemeGraphicNodeDelegate {
    internal func didTap(node: LineSchemeGraphicNode) {
        for aNode in scrollContent.subviews {
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
