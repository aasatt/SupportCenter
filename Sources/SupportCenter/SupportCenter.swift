//
//  SupportCenter.swift
//
//
//  Created by Aaron Satterfield on 5/8/20.
//

import Foundation
import UIKit
import SwiftUI

public enum SupportCenter {

    /// Set the SupportCenter configurations
    /// - Parameters:
    ///   - sendgridToken: Your API token used to authenticate with Sendgrid
    ///   - supportEmail: The email address you would like support emails to be sent to
    ///   - fromEmail: The email address that you have verified as a sender in Sendgrid.
    public static func setup(sendgridToken: String, supportEmail: String, fromEmail: String) -> MailServer {
        let configs = Configuration(
            apiToken: sendgridToken,
            supportEmail: supportEmail,
            fromEmail: fromEmail
        )

        return .sendgrid(configuration: configs)
    }

    public static func setup(smtp2goAPIKey: String, supportEmail: String, fromEmail: String) -> MailServer {
        let configs = Configuration(
            apiToken: smtp2goAPIKey,
            supportEmail: supportEmail,
            fromEmail: fromEmail
        )

        return .smtp2go(configuration: configs)
    }

    /// Present the support controller on your view controller
    /// - Parameter controller: Controller to present the support controller on
    @MainActor
    public static func present(with mailServer: MailServer, from controller: UIViewController, presentingViewName: String? = nil, reportOptions: [ReportOption]? = nil, delegate: SupportCenterViewControllerDelegate? = nil) {
        let supportController = SupportCenter.controller(with: mailServer, from: controller, reportOptions: reportOptions, delegate: delegate)
        controller.present(supportController, animated: false, completion: nil)
    }

    @MainActor
    public static func controller(with mailServer: MailServer, from controller: UIViewController? = nil, presentingViewName: String? = nil, reportOptions: [ReportOption]? = nil, delegate: SupportCenterViewControllerDelegate? = nil) -> UIViewController {
        let metadata = Metadata(controller: controller, viewName: presentingViewName)

        let controller = SupportCenterViewController(options: reportOptions ?? DefaultReportOption.allCases, metadata: metadata, mailServer: mailServer)
        controller.delegate = delegate

        return controller
    }

    @MainActor @ViewBuilder
    public static func button(@ViewBuilder label: @escaping () -> some View) -> some View {
        SupportButton(label: label)
    }
}
