//
//  SupportCenter.swift
//
//
//  Created by Aaron Satterfield on 5/8/20.
//

import Foundation
import UIKit

public struct SupportCenter {

    static var sendgrid: Sendgrid?

    /// Set the SupportCenter configurations
    /// - Parameters:
    ///   - sendgridToken: Your API token used to authenticate with Sendgrid
    ///   - supportEmail: The email address you would like support emails to be sent to
    ///   - fromEmail: The email address that you have verified as a sender in Sendgrid.
    public static func setup(sendgridToken: String, supportEmail: String, fromEmail: String) {
        let configs = Configuration(sendgridToken: sendgridToken, supportEmail: supportEmail, fromEmail: fromEmail)
        sendgrid = Sendgrid(configuration: configs)
    }

    /// Present the support controller on your view controller
    /// - Parameter controller: Controller to present the support controller on
    public static func present(from controller: UIViewController, reportOptions: [ReportOption]? = nil, delegate: SupportCenterViewControllerDelegate? = nil) {
        let supportController = SupportCenter.controller(from: controller, reportOptions: reportOptions, delegate: delegate)
        controller.present(supportController, animated: false, completion: nil)
    }

    public static func controller(from controller: UIViewController, reportOptions: [ReportOption]? = nil, delegate: SupportCenterViewControllerDelegate? = nil) -> UIViewController {
        guard sendgrid != nil else {
            assertionFailure("Sendgrid token not set. Please call setSengridToken before presenting this controller.")
            return UIViewController()
        }

        sendgrid?.metadata = Metadata(controller: controller)

        let controller = SupportCenterViewController(options: reportOptions ?? DefaultReportOption.allCases)
        controller.delegate = delegate

        return controller
    }

}
