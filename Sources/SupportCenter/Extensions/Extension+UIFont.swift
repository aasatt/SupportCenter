//
//  Extension+UIFont.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation
import UIKit

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
