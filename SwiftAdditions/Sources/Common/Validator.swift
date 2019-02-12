import Foundation

public enum Validator {
    case email
    case phone
    case ssn
    case zipcode
    case password // Minimum criteria and any length, any chars

    public var format: String {
        switch self {
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,63}"
        case .phone:
            return "[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"
        case .ssn:
            return "^(?!000|666)[0-8][0-9]{2}-(?!00)[0-9]{2}-(?!0000)[0-9]{4}$"
        case .zipcode:
            return "^(\\d{5}(-\\d{4})?|[a-z]\\d[a-z][- ]*\\d[a-z]\\d)$"
        case .password:
            return "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+"
        }
    }

    public var errorMessage: String {
        var message = "Invalid "
        switch self {
        case .email:
            message += "Email"
        case .phone:
            message += "Phone"
        case .ssn:
            message += "Social Security Number"
        case .zipcode:
            message += "Zipcode"
        case .password:
            message = "Password Does Not Meet Requirement"
        }
        return message
    }
}

extension String {
    public func validate(_ validator: Validator) -> Bool {
        return isMatch(validator.format)
    }
}
