import UIKit

enum SpinnerTransitionType {
    case presenting, dismissing
}

class SpinnerPresentationBase: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval
    var isPresenting: Bool
    var originFrame: CGRect
    
    init(withDuration duration: TimeInterval, forTransitionType type: SpinnerTransitionType, originFrame: CGRect) {
        self.duration = duration
        self.isPresenting = type == .presenting
        self.originFrame = originFrame
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.viewController(forKey: .from)!.view
        let toView = transitionContext.viewController(forKey: .to)!.view

        fromView?.isUserInteractionEnabled = false
        toView?.isUserInteractionEnabled = false
        
        let detailView = self.isPresenting ? toView : fromView
        detailView?.alpha = self.isPresenting ? 0.0 : 1.0
        
        if self.isPresenting {
            containerView.addSubview(toView!)
        } else {
            containerView.insertSubview(toView!, belowSubview: fromView!)
        }
        
        detailView?.frame.origin = self.isPresenting ? self.originFrame.origin : CGPoint(x: 0, y: 0)
        detailView?.frame.size.width = self.isPresenting ? self.originFrame.size.width : containerView.bounds.width
        detailView?.layoutIfNeeded()

        UIView.animate(withDuration: self.duration, animations: { () -> Void in
            detailView?.frame = self.isPresenting ? containerView.bounds : self.originFrame
            detailView?.layoutIfNeeded()
            detailView?.alpha = self.isPresenting ? 1.0 : 0.0
        }) { (completed: Bool) -> Void in
            fromView?.isUserInteractionEnabled = true
            toView?.isUserInteractionEnabled = true
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
