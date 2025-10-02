//
//  STMP2GO.swift
//  SupportCenter
//
//  Created by Aaron Satterfield on 9/19/25.
//

import Foundation

extension MailServer {
    static func smtp2go(configuration: Configuration) -> MailServer {
        let host = "https://api.smtp2go.com"

        lazy var jsonEncoder: JSONEncoder = {
            let e = JSONEncoder()
            e.keyEncodingStrategy = .convertToSnakeCase
            return e
        }()


        return .init(
            sendSupportEmail: { [jsonEncoder] type, senderEmail, message, attachments, metadata in
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
                        senderEmail: senderEmail,
                        subject: type.emailSubject,
                        message: message,
                        metadata: metadata,
                        attachments: attachments.isEmpty ? nil : attachments
                    )

                    request.httpBody = try jsonEncoder.encode(body)


                    do {
                        let response = try await URLSession.shared.data(for: request)
                        return smtp2goSendEmailResponse(from: response)
                    } catch {
                        throw MailServerError.requestError(error)
                    }
                } catch let error as MailServerError {
                    throw error
                } catch {
                    throw MailServerError.failedToEncodeEmailBody(error)
                }
            }, supportEmail: {
                configuration.supportEmail
            }
        )
    }
}

private func smtp2goSendEmailResponse(from response: (Data, URLResponse)) -> SendEmailResponse {
    guard let http = response.1 as? HTTPURLResponse else {
        return .failure(.unknown)
    }

    switch http.statusCode {
    case 200 ..< 300:
        guard (try? JSONDecoder().decode(SMTP2GOResponse.self, from: response.0))?.data.didSucceed == true else {
            return .failure(.unknown)
        }

        return .success(())

    default:
        return .failure(SendEmailResponseError(statusCode: http.statusCode))
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
    let customHeaders: [[String: String]]

    init(
        to: String,
        from: String,
        senderEmail: String,
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
        customHeaders = [
            [
                "header": "Reply-To",
                "value": senderEmail
            ]
        ]
    }
}

struct SMTP2GOResponse: Decodable {
    let data: Data

    struct Data: Decodable {
        let succeeded: Int

        var didSucceed: Bool { succeeded == 1 }
    }
}
