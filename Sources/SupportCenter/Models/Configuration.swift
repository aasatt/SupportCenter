//
//  Configuration.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation

struct Configuration {

    var sendgridToken: String
    var supportEmail: String
    var fromEmail: String

    var authorizationHeaderValue: String {
        return "Bearer \(sendgridToken)"
    }

}
