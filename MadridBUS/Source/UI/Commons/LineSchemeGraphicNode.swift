import UIKit

protocol LineSchemeGraphicNodeDelegate {
    func didTap(node: LineSchemeGraphicNode)
}

class LineSchemeGraphicNode: UIView {
    var node: LineSchemeNodeModel
    var delegate: LineSchemeGraphicNodeDelegate?
    
    var isSelected: Bool = false
    
    internal var dotShape = CAShapeLayer()
    internal var lineShape = CAShapeLayer()
    internal var dotRadius: CGFloat
    internal var nameLabel = UILabel()
    internal var thickness: CGFloat = 0.0
    
    internal var theme: LineSchemeTheme
    
    internal var labelWrapper = UIView()
    
    init(with node: LineSchemeNodeModel, dotRadius: CGFloat, theme: LineSchemeTheme) {
        self.node = node
        self.dotRadius = dotRadius
        self.theme = theme
        super.init(frame: .zero)
        
        backgroundColor = .clear
        clipsToBounds = true
        layer.masksToBounds = true
        
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.backgroundColor = .clear
        labelWrapper.addSubview(nameLabel)
        
        labelWrapper.clipsToBounds = true
        labelWrapper.layer.masksToBounds = true
        addSubview(labelWrapper)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSelf))
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapSelf() {
        if !isSelected {
            labelWrapper.backgroundColor = theme.highlightedBackgroundColor
            nameLabel.textColor = theme.highlightedTitleColor
            lineShape.fillColor = theme.highlightedForegroundColor.cgColor
            dotShape.strokeColor = theme.highlightedForegroundColor.cgColor
            
            isSelected = true
            
            delegate?.didTap(node: self)
        }
    }
    
    func reset() {
        labelWrapper.backgroundColor = theme.normalBackgroundColor
        nameLabel.textColor = theme.normalTitleColor
        lineShape.fillColor = theme.normalForegroundColor.cgColor
        dotShape.strokeColor = theme.normalForegroundColor.cgColor
        
        isSelected = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelWrapper.frame = CGRect(x: (dotRadius * 3), y: 0, width: (bounds.width - (dotRadius * 4)) - dotRadius, height: bounds.height)
        nameLabel.frame = CGRect(x: 4.0, y: 0, width: labelWrapper.frame.size.width - 8, height: labelWrapper.frame.size.height)
        
        labelWrapper.layer.cornerRadius = 4.0
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        thickness = dotRadius * 0.6
        
        let dotCenter = CGPoint(x: dotRadius * 2, y: rect.midY)
        let circlePath = UIBezierPath(arcCenter: dotCenter, radius: dotRadius, startAngle: 0, endAngle: CGFloat(2.0) * CGFloat(M_PI), clockwise: true)
        dotShape =  CAShapeLayer()
        dotShape.path = circlePath.cgPath
        dotShape.fillColor = UIColor.white.cgColor
        dotShape.strokeColor = theme.normalForegroundColor.cgColor
        dotShape.lineWidth = thickness
        
        layer.addSublayer(dotShape)
    }
}
