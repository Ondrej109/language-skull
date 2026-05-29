import Foundation
import SwiftData

@Model
final class SubscriptionStatus {
    var isPro: Bool
    var trialEndDate: Date?
    var subscriptionEndDate: Date?
    var lastReceiptValidationDate: Date?

    // Simplified relationship - removed inverse to avoid circular reference errors
    var user: UserProfile?

    init(
        isPro: Bool = false,
        trialEndDate: Date? = nil,
        subscriptionEndDate: Date? = nil,
        lastReceiptValidationDate: Date? = nil
    ) {
        self.isPro = isPro
        self.trialEndDate = trialEndDate
        self.subscriptionEndDate = subscriptionEndDate
        self.lastReceiptValidationDate = lastReceiptValidationDate
    }
}
