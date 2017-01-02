import UIKit

class LineSchemeNodeTop: LineSchemeGraphicNode {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var linePath = UIBezierPath()
        switch theme.orientation {
        case .vertical:
            linePath = UIBezierPath(rect: CGRect(x: (dotRadius * 2) - (thickness * 0.5), y: rect.midY, width: thickness, height: rect.height * 0.5))
        
        case .horizontal:
            linePath = UIBezierPath(rect: CGRect(x: rect.midX, y: dotRadius + (thickness * 0.5), width: rect.width * 0.5, height: thickness))
        }
        
        lineShape = CAShapeLayer()
        lineShape.path = linePath.cgPath
        lineShape.fillColor = theme.normalForegroundColor.cgColor
        
        layer.insertSublayer(lineShape, below: dotShape)
    }
}
