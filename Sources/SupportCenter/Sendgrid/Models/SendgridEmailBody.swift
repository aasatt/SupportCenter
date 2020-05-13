//
//  SendgridEmailBody.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation

struct SendgridEmailBody: Codable {

    struct Recipient: Codable {
        let email: String
        let name: String?
    }

    struct Personalizations: Codable {
        let to: [Recipient]
        let cc: [Recipient]?
        let bcc: [Recipient]?

        init(to: [Recipient], cc: [Recipient]? = nil, bcc: [Recipient]? = nil) {
            self.to = to
            self.cc = cc
            self.bcc = bcc
        }
    }

    struct Content: Codable {

        enum MimeType: String, Codable {
            case text = "text/plain", html = "text/html"
        }

        let value: String
        let type: MimeType?
    }

    struct Attachment: Codable {

        let content: String
        let type: String?
        let filename: String

    }

    var personalizations: [Personalizations]
    var from: Recipient
    var replyTo: Recipient
    var subject: String
    var content: [Content]
    var attachments: [Attachment]?

    init(to: String, from: String, replyTo: String, subject: String, content: [Content], attachments: [SendgridEmailBody.Attachment]) {
        let to = Recipient(email: to, name: nil)
        personalizations = [Personalizations(to: [to])]
        self.from = Recipient(email: from, name: nil)
        self.replyTo = Recipient(email: replyTo, name: nil)
        self.subject = subject
        self.content = content
        if !attachments.isEmpty {
            self.attachments = attachments
        }
    }

}
