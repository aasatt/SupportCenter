//
//  Attachment+Sendgrid.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation

extension Attachment {

    func getSengridAttachment() -> SendgridEmailBody.Attachment {
        let base64Data = (try? Data(contentsOf: url))?.base64EncodedString() ?? "===="
        return SendgridEmailBody.Attachment(content: base64Data, type: url.getMimeType(), filename: url.lastPathComponent)
    }

}
