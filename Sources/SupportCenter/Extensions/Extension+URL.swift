//
//  Extension+URL.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation
import CoreServices

extension URL {

    public func getMimeType() -> String {
        guard !pathExtension.isEmpty else {
            return "application/octet-stream"
        }
        let fileExtension: CFString = pathExtension as CFString
        guard let extUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil)?.takeUnretainedValue() else {
            return "application/octet-stream"
        }
        guard let mimeUTI = UTTypeCopyPreferredTagWithClass(extUTI, kUTTagClassMIMEType)?.takeUnretainedValue() else {
            return "application/octet-stream"
        }
        return String(mimeUTI)
    }

}
