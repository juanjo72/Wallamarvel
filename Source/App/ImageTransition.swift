//
//  ImageTransition.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 06/11/2020.
//

import UIKit

final class ImageTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? ImageTransitionController,
              let toVC = transitionContext.viewController(forKey: .to) as? ImageTransitionController,
              let sourceImageView = fromVC.transitionImageView,
              let targetImageView = toVC.transitionImageView else {
                return
              }
        let containerView = transitionContext.containerView
        
        containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        fromVC.view.alpha = 0
        
        let originFrame = sourceImageView.convert(sourceImageView.frame, to: containerView)
        let dummyView = UIImageView(frame: originFrame)
        dummyView.image = sourceImageView.image
        dummyView.contentMode = .scaleAspectFill
        dummyView.clipsToBounds = true
        containerView.addSubview(dummyView)
        containerView.layoutIfNeeded()
        
        toVC.view.frame = containerView.frame
        toVC.view.layoutIfNeeded()
        let targetFrame = targetImageView.convert(targetImageView.frame, to: containerView)
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            dummyView.frame = targetFrame
            containerView.layoutIfNeeded()
        }, completion: { copletion in
            containerView.addSubview(toVC.view)
            fromVC.view.alpha = 1
            dummyView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
}
