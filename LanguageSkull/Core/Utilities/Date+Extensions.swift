import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

extension Calendar {
    func daysBetween(_ start: Date, and end: Date) -> Int {
        let startDay = startOfDay(for: start)
        let endDay = startOfDay(for: end)
        return dateComponents([.day], from: startDay, to: endDay).day ?? 0
    }
}
