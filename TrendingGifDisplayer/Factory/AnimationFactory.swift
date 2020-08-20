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

        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class AnimationFactory {
    static func makeSlideIn(duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, _, tableView in
            cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

            UIView.animate(
                withDuration: duration,
                delay: delayFactor,
                options: [.curveEaseOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
}

final class Animator {
    private var hasAnimatedAllCells = false
    private let animation: Animation

    init(animation: @escaping Animation) {
        self.animation = animation
    }

    func animate(cell: GifTableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }

        animation(cell, indexPath, tableView)

        hasAnimatedAllCells = true
    }
}
