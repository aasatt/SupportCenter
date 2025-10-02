//
//  MailServer.swift
//  SupportCenter
//
//  Created by Aaron Satterfield on 9/19/25.
//

import Foundation

public struct MailServer {
    let sendSupportEmail: @Sendable (
        _ type: ReportOption,
        _ senderEmail: String,
        _ message: String,
        _ attachments: [Attachment],
        _ metadata: Metadata?
    ) async throws -> SendEmailResponse

    let supportEmail: @Sendable () -> String
}

public enum MailServerError: Error {
    case failedToEncodeEmailBody(Error)
    case requestError(Error)
}
