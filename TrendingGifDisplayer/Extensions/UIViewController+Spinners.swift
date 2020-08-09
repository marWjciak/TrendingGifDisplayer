//
//  UIViewController+Spinners.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 09/08/2020.
//

import Spinners
import UIKit

extension UIViewController {
    var spinnerTag: Int { return 999999 }

    func startSpinner(with viewController: UIViewController) {
        DispatchQueue.main.async {
            let spinner = Spinners(type: .cube, with: viewController)
            spinner.setCustomSettings(borderColor: .systemYellow, backgroundColor: .clear, alpha: 0.8)
            spinner.tag = self.spinnerTag

            spinner.present()
        }
    }

    func stopSpinner() {
        DispatchQueue.main.async {
            guard let spinner = self.view.subviews.filter({
                $0.tag == self.spinnerTag
            }).first as? Spinners else { return }
            
            spinner.dismiss()
        }
    }
}
