//
//  Sendgrid.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation

class Sendgrid: NSObject {

    let configuration: Configuration
    var metadata: Metadata?

    let sendEmailUrl = URL(string: "https://api.sendgrid.com/v3/mail/send")!
    let sendEmailHTTPMethod = "POST"
    let authorizationHeaderKey = "Authorization"
    let contentTypeHeader: (key: String, value: String) = ("Content-Type", "application/json")

    lazy var jsonEncoder: JSONEncoder = {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        return e
    }()

    init(configuration: Configuration) {
        self.configuration = configuration
        super.init()
    }

    func sendSupportEmail(ofType type: ReportOption, senderEmail: String, message: String, attachments: [Attachment], completion: @escaping (_: SendEmailResponse) -> Void) {
        let content = [SendgridEmailBody.Content(value: createSupportHTML(with: message, metadata: metadata), type: .html)]
        let emailAttachments = attachments.map { $0.getSengridAttachment() }
        let emailBody = SendgridEmailBody(to: configuration.supportEmail, from: configuration.fromEmail, replyTo: senderEmail, subject: type.emailSubject, content: content, attachments: emailAttachments)
        guard let body = try? jsonEncoder.encode(emailBody) else {
            // TODO: Could not create body
            return
        }
        var request = URLRequest(url: sendEmailUrl)
        request.httpMethod = sendEmailHTTPMethod
        request.httpBody = body
        request.setValue(contentTypeHeader.value, forHTTPHeaderField: contentTypeHeader.key)
        request.setValue(configuration.authorizationHeaderValue, forHTTPHeaderField: authorizationHeaderKey)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let result = response?.getSendgridResponse() ?? .failure(.unknown)
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
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
