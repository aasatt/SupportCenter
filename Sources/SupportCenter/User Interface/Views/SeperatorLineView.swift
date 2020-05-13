//
//  File.swift
//  
//
//  Created by Aaron Satterfield on 5/8/20.
//

import Foundation
import UIKit

class SeperatorLineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initalize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initalize()
    }

    func initalize() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.tertiarySystemFill
        heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }

}
