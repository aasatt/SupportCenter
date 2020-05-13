//
//  ReportOption.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation
import UIKit

public protocol ReportOption {
    var icon: UIImage { get }
    var title: String { get }
    var description: String { get }
    var emailSubject: String { get }
}

enum DefaultReportOption: ReportOption, CaseIterable {

    case bug, feature

    var icon: UIImage {
        switch self {
        case .bug:
            return UIImage(systemName: "ant.fill")!
        case .feature:
            return UIImage(systemName: "star.fill")!
        }
    }

    var title: String {
        switch self {
        case .bug:
            return "Report a bug"
        case .feature:
            return "Suggest an improvement"
        }
    }

    var description: String {
        switch self {
        case .bug:
            return "Something in the app is broken or is not working as expected"
        case .feature:
            return "Share your idea to make this app even better"
        }
    }

    var emailSubject: String {
        switch self {
        case .bug:
            return "Bug Report"
        case .feature:
            return "Suggested Improvement"
        }
    }

}
