//
//  Extension+FileManager.swift
//  
//
//  Created by Aaron Satterfield on 5/11/20.
//

import Foundation

extension FileManager {

    func sizeForItem(at url: URL) -> Int? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            return attributes[.size] as? Int
        } catch {
            print("Could not get file attributes at: \(url.path)")
            return nil
        }
    }

}
