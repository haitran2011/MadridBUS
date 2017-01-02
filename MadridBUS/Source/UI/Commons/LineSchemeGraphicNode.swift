import UIKit

protocol LineSchemeGraphicNodeDelegate: class {
    func didTap(node: LineSchemeGraphicNode)
}

class LineSchemeGraphicNode: UIView {
    var node: LineSchemeNodeModel
    weak var delegate: LineSchemeGraphicNodeDelegate?
    
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
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.backgroundColor = .clear
        labelWrapper.addSubview(nameLabel)
        
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: labelWrapper, attribute: .leading, multiplier: 1.0, constant: 4.0).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: labelWrapper, attribute: .trailing, multiplier: 1.0, constant: -4.0).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: labelWrapper, attribute: .top, multiplier: 1.0, constant: 4.0).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: labelWrapper, attribute: .bottom, multiplier: 1.0, constant: -4.0).isActive = true
        
        labelWrapper.translatesAutoresizingMaskIntoConstraints = false
        labelWrapper.clipsToBounds = true
        labelWrapper.layer.masksToBounds = true
        addSubview(labelWrapper)
        
        switch theme.orientation {
        case .vertical:
            nameLabel.textAlignment = .left
            NSLayoutConstraint(item: labelWrapper, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: dotRadius * 3).isActive = true
            NSLayoutConstraint(item: labelWrapper, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: labelWrapper, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: labelWrapper, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
            
        case .horizontal:
            nameLabel.textAlignment = .center
            NSLayoutConstraint(item: labelWrapper, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: labelWrapper, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: labelWrapper, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: dotRadius * 2).isActive = true
            NSLayoutConstraint(item: labelWrapper, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        }
        
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
            nameLabel.font = theme.highlightedTitleFont
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

        labelWrapper.layer.cornerRadius = 4.0
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        thickness = dotRadius * 0.6
        
        var dotCenter = CGPoint()
        switch theme.orientation {
        case .vertical:     dotCenter = CGPoint(x: dotRadius * 2, y: rect.midY)
        case .horizontal:   dotCenter = CGPoint(x: rect.midX, y: dotRadius + thickness)

        }

        let circlePath = UIBezierPath(arcCenter: dotCenter, radius: dotRadius, startAngle: 0, endAngle: CGFloat(2.0) * CGFloat(M_PI), clockwise: true)
        dotShape =  CAShapeLayer()
        dotShape.path = circlePath.cgPath
        dotShape.fillColor = UIColor.white.cgColor
        dotShape.strokeColor = theme.normalForegroundColor.cgColor
        dotShape.lineWidth = thickness
        
        layer.addSublayer(dotShape)
    }
}
