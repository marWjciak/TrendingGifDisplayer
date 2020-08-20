//
//  UIViewController+Spinners.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 09/08/2020.
//

import Spinners
import UIKit

//MARK: - Spinner in View Controller

extension UIViewController {
    var spinnerTag: Int { return 999999 }

    func startSpinner() {
        DispatchQueue.main.async {
            let spinner = Spinners(type: .cube, with: self)
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


//MARK: - Show Alert Window

extension UIViewController {
    func presentAlertPopup(title: String,
                           message: String,
                           actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true, completion: nil)
    }
}
