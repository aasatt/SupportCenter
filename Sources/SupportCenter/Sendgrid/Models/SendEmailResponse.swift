//
//  SendEmailResponse.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation

typealias SendEmailResponse = Result<Void, SendEmailResponseError>

enum SendEmailResponseError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case payloadTooLarge = 413
    case unknown = -1

    init(statusCode: Int) {
        self = SendEmailResponseError(rawValue: statusCode) ?? .unknown
    }

    var localizedDescription: String {
        assertionFailure()
        return "Something went wrong"
    }

    func errorMessage(supportEmail: String) -> String {
        switch self {
        case .badRequest, .unauthorized, .forbidden, .unknown:
            return "Please try again or contact us at \(supportEmail)"
        case .payloadTooLarge:
            return "Attachment size too large"
        }
    }
}

