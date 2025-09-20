//
//  Sendgrid.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation

extension MailServer {
    static func sendgrid(configuration: Configuration) -> Self {
        let sendEmailUrl = URL(string: "https://api.sendgrid.com/v3/mail/send")!
        let sendEmailHTTPMethod = "POST"
        let authorizationHeaderKey = "Authorization"
        let contentTypeHeader: (key: String, value: String) = ("Content-Type", "application/json")

        lazy var jsonEncoder: JSONEncoder = {
            let e = JSONEncoder()
            e.keyEncodingStrategy = .convertToSnakeCase
            return e
        }()

        return .init(
            sendSupportEmail: { [jsonEncoder] type, senderEmail, message, attachments, metadata throws(MailServerError) in
                let content = [SendgridEmailBody.Content(value: createSupportHTML(with: message, metadata: metadata), type: .html)]
                let emailAttachments = attachments.map { $0.getSengridAttachment() }
                let emailBody = SendgridEmailBody(to: configuration.supportEmail, from: configuration.fromEmail, replyTo: senderEmail, subject: type.emailSubject, content: content, attachments: emailAttachments)

                do {
                    let body = try jsonEncoder.encode(emailBody)

                    var request = URLRequest(url: sendEmailUrl)
                    request.httpMethod = sendEmailHTTPMethod
                    request.httpBody = body
                    request.setValue(contentTypeHeader.value, forHTTPHeaderField: contentTypeHeader.key)
                    request.setValue(configuration.sendgridAuthorizationHeaderValue, forHTTPHeaderField: authorizationHeaderKey)

                    do {
                        let response = try await URLSession.shared.data(for: request)
                        return response.1.getSendgridResponse()
                    } catch {
                        throw MailServerError.requestError(error)
                    }
                } catch let error as MailServerError {
                    throw error
                } catch {
                    throw .failedToEncodeEmailBody(error)
                }
            }, supportEmail: {
                configuration.supportEmail
            }
        )
    }
}

private extension URLResponse {
    func getSendgridResponse() -> SendEmailResponse {
        guard let response = self as? HTTPURLResponse else { return .failure(.unknown) }
        switch response.statusCode {
        case 202:
            return .success(Void())
        default:
            return .failure(SendEmailResponseError(statusCode: response.statusCode))
        }
    }
}
