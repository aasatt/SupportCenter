//
//  ProgressAlert.swift
//  
//
//  Created by Aaron Satterfield on 5/20/20.
//

import Foundation
import UIKit

class ProgressAlert: UIAlertController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.tintColor = .label
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        view.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0).isActive = true
    }

}
