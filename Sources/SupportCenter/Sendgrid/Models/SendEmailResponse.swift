//
//  SendEmailResponse.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation

typealias SendEmailResponse = Result<Void, SendEmailResponseError>

enum SendEmailResponseError: Int, Error {
    case badRequest = 400, unauthorized = 401, forbidden = 403, payloadTooLarge = 413, unknown = -1

    init(statusCode: Int) {
        self = SendEmailResponseError(rawValue: statusCode) ?? .unknown
    }

    var localizedDescription: String {
        switch self {
        case .badRequest, .unauthorized, .forbidden, .unknown:
            return "Please try again or contact us at \(SupportCenter.sendgrid?.configuration.supportEmail ?? "---")"
        case .payloadTooLarge:
            return "Attachment size too large"
        }
    }
}

