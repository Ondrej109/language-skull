import Foundation
import UserNotifications

enum NotificationServiceError: LocalizedError {
    case permissionDenied

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            "Notification permission was denied. You can enable reminders later in Settings."
        }
    }
}

@MainActor
final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    func requestMorningReminderPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()

        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                await scheduleMorningReminder()
            }
            return granted
        } catch {
            print("NotificationService authorization error: \(error)")
            return false
        }
    }

    func scheduleMorningReminder() async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["morning.reminder"])

        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0

        let content = UNMutableNotificationContent()
        content.title = "Morning Training"
        content.body = "Your morning session is ready. A few minutes now builds a lasting habit."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "morning.reminder", content: content, trigger: trigger)

        do {
            try await center.add(request)
        } catch {
            print("NotificationService schedule error: \(error)")
        }
    }
}
