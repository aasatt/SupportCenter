//
//  EmailValidator.swift
//  
//
//  Created by Aaron Satterfield on 5/8/20.
//

import Foundation

public protocol StringValidator {
    /// Returns a sanitized string if the input is valid or nil otherwise
    static func validate(_ string: String) -> String?
}

public struct ValidatedString<Validator: StringValidator> {
    public let rawValue: String

    public init?(_ rawValue: String) {
        guard let validated = Validator.validate(rawValue) else {return nil}
        self.rawValue = validated
    }
}

public typealias Email = ValidatedString<EmailValidator>

public enum EmailValidator: StringValidator {

    public static func validate(_ email: String) -> String? {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        guard NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) else {return nil}
        return email
    }

}
