//
//  STMP2GO.swift
//  SupportCenter
//
//  Created by Aaron Satterfield on 9/19/25.
//

import Foundation

extension MailServer {
    static func stmp2go(configuration: Configuration) -> MailServer {
        let host = "https://api.smtp2go.com"

        lazy var jsonEncoder: JSONEncoder = {
            let e = JSONEncoder()
            e.keyEncodingStrategy = .convertToSnakeCase
            return e
        }()


        return .init(
            sendSupportEmail: { [jsonEncoder] type, senderEmail, message, attachments, metadata throws(MailServerError) in
                // Body cannot be empty
                let message = message.isEmpty ? "No content" : message

                var request = URLRequest(url: URL(string: "\(host)/v3/email/send")!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(configuration.apiToken, forHTTPHeaderField: "X-Smtp2go-Api-Key")
                request.setValue("application/json", forHTTPHeaderField: "accept")

                do {
                    let body = SMTP2GORequestBody(
                        to: configuration.supportEmail,
                        from: configuration.fromEmail,
                        subject: type.emailSubject,
                        message: message,
                        metadata: metadata,
                        attachments: attachments.isEmpty ? nil : attachments
                    )

                    request.httpBody = try jsonEncoder.encode(body)


                    do {
                        let response = try await URLSession.shared.data(for: request)
                        return response.1.getSTMP2GOResponse()
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

extension URLResponse {
    func getSTMP2GOResponse() -> SendEmailResponse {
        guard let response = self as? HTTPURLResponse else { return .failure(.unknown) }
        switch response.statusCode {
        case 200 ..< 300:
            return .success(Void())
        default:
            return .failure(SendEmailResponseError(statusCode: response.statusCode))
        }
    }
}

struct SMTP2GOAttachment: Codable {
    var filename: String
    var fileblob: String
    var mimetype: String

    init?(attachment: Attachment) {
        filename = attachment.url.lastPathComponent
        guard let blob = try? Data(contentsOf: attachment.url).base64EncodedString() else {
            return nil
        }

        fileblob = blob
        mimetype = attachment.url.getMimeType()
    }
}


struct SMTP2GORequestBody: Encodable {
    let sender: String
    let to: String
    let subject: String
    let htmlBody: String
    let attachments: [SMTP2GOAttachment]?

    init(
        to: String,
        from: String,
        subject: String,
        message: String,
        metadata: Metadata?,
        attachments: [Attachment]?
    ) {
        self.to = to
        sender = from
        self.subject = subject
        htmlBody = createSupportHTML(with: message, metadata: metadata)
        self.attachments = attachments?.compactMap { .init(attachment: $0) }
    }
}
