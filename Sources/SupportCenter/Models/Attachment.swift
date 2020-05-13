//
//  Attachment.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation
import UIKit

struct Attachment: Equatable {

    enum AttachmentType {
        case image, movie
    }

    let type: AttachmentType
    let url: URL
    var size: Int = 0
    var thumbnail: UIImage

    init?(type: AttachmentType, url: URL, image: UIImage) {
        self.type = type
        self.url = url
        guard let bytes = FileManager.default.sizeForItem(at: url) else { return nil }
        self.size = bytes
        self.thumbnail = image
    }

}
