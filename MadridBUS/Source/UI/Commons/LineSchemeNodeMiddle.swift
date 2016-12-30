import UIKit

class LineSchemeNodeMiddle: LineSchemeGraphicNode {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let linePath = UIBezierPath(rect: CGRect(x: (dotRadius * 2) - (thickness * 0.5), y: 0, width: thickness, height: rect.height))
        lineShape = CAShapeLayer()
        lineShape.path = linePath.cgPath
        lineShape.fillColor = theme.normalForegroundColor.cgColor
        
        layer.insertSublayer(lineShape, below: dotShape)
    }
}
