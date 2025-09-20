//
//  Configuration.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation

struct Configuration {

    var apiToken: String
    var supportEmail: String
    var fromEmail: String

    var sendgridAuthorizationHeaderValue: String {
        return "Bearer \(apiToken)"
    }
}
