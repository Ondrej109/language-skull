import Foundation

enum GreetingHelper {
    static func timeBasedGreeting(firstName: String?) -> String {
        let hour = Calendar.current.component(.hour, from: .now)
        let salutation: String
        switch hour {
        case 5..<12: salutation = "Good morning"
        case 12..<17: salutation = "Good afternoon"
        case 17..<22: salutation = "Good evening"
        default: salutation = "Good night"
        }

        if let firstName, !firstName.isEmpty {
            return "\(salutation), \(firstName)"
        }
        return salutation
    }
}
