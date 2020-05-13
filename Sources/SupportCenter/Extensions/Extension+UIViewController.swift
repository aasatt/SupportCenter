//
//  Extension+UIViewController.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation
import UIKit

extension UIViewController {

    // MARK: UIAlertController

    @discardableResult
    func presentAlert(title: String?, description: String?, showDismiss: Bool = true, dismissed: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        if showDismiss {
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
                dismissed?()
            }))
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        return alert
    }

}
