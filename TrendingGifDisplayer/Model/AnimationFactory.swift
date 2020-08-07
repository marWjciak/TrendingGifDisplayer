//
//  AnimationFactory.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 07/08/2020.
//

import Foundation
import QuartzCore.CAAnimation
import UIKit

typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void


open class FadeInAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }

        transitionContext.containerView.addSubview(toViewController.view)

        toViewController.view.frame = fromViewController.view.frame
        toViewController.view.alpha = 0

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

open class FadeOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }

        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

        toViewController.view.frame = fromViewController.view.frame

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
