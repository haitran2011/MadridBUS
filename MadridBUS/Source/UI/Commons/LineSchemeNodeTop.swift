import UIKit

class LineSchemeNodeTop: LineSchemeGraphicNode {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let linePath = UIBezierPath(rect: CGRect(x: (dotRadius * 2) - (thickness * 0.5), y: rect.midY, width: thickness, height: rect.height * 0.5))
        lineShape = CAShapeLayer()
        lineShape.path = linePath.cgPath
        lineShape.fillColor = theme.normalForegroundColor.cgColor
        
        layer.insertSublayer(lineShape, below: dotShape)
    }
}
