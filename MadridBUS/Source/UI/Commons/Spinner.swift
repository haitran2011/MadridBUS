import UIKit

protocol Spinner {
    
}

class SpinnerBase: UIViewController, Spinner {
    fileprivate var radius: CGFloat = 20
    fileprivate var color: UIColor = Colors.pink
    fileprivate let spinnerLayer = CAShapeLayer()
    fileprivate var startAngle: CGFloat = CGFloat(M_PI * -0.5)
    fileprivate var finalAngle: CGFloat {
        get { return CGFloat(2 * M_PI * 0.95) + CGFloat(M_PI * -0.5) }
        set { }
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        drawSpinner()
        animateSpinner()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
    }
    
    private func drawSpinner() {
        let spinnerCenter = CGPoint(x: view.bounds.midX, y: view.bounds.midY)

        let circlePath = UIBezierPath(arcCenter: spinnerCenter,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: finalAngle,
                                      clockwise: true)
        spinnerLayer.path = circlePath.cgPath
        spinnerLayer.fillColor = UIColor.clear.cgColor
        spinnerLayer.lineWidth = 5
        spinnerLayer.strokeEnd = 0.0
        spinnerLayer.strokeColor = color.cgColor
        spinnerLayer.lineCap = kCALineCapRound
        spinnerLayer.position = spinnerCenter
        spinnerLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spinnerLayer.frame = view.frame
        
        view.layer.addSublayer(spinnerLayer)
    }
    
    private func animateSpinner() {
        DispatchQueue.main.async {
            let fillAnimation = CABasicAnimation(keyPath: "strokeEnd")
            fillAnimation.duration = 1.0
            fillAnimation.fromValue = 0
            fillAnimation.toValue = 1
            fillAnimation.autoreverses = true
            fillAnimation.repeatCount = Float.infinity
            self.spinnerLayer.add(fillAnimation, forKey: "fill spinner circle")
            
            let spinnerRotation = CABasicAnimation(keyPath: "transform.rotation.z")
            spinnerRotation.duration = 0.8
            spinnerRotation.repeatCount = Float.infinity
            spinnerRotation.fromValue = 0.0
            spinnerRotation.toValue = Float(M_PI * 2.0)
            self.spinnerLayer.add(spinnerRotation, forKey: "rotate around center")
        }
    }
}

extension SpinnerBase: UIViewControllerTransitioningDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SpinnerPresentationBase(withDuration: 0.6, forTransitionType: .presenting, originFrame: presenting.view.frame)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SpinnerPresentationBase(withDuration: 0.6, forTransitionType: .dismissing, originFrame: dismissed.view.frame)
    }
}
