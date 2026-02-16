import SwiftUI

enum CalendarStyle {
    case creation
    case detail
}

struct MonthCalendarView: View {
    @Binding var selectedDate: Date
    var style: CalendarStyle = .creation
    var eventDates: Set<DateComponents> = []
    var onDayTap: (@MainActor (Date) -> Void)?

    private let calendar: Calendar = {
        var cal = Calendar.current
        cal.firstWeekday = 1
        return cal
    }()
    @State private var displayedMonth: Date

    init(selectedDate: Binding<Date>, style: CalendarStyle = .creation, eventDates: Set<DateComponents> = []) {
        _selectedDate = selectedDate
        self.style = style
        self.eventDates = eventDates
        self.onDayTap = nil
        _displayedMonth = State(initialValue: selectedDate.wrappedValue)
    }

    private var monthName: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM"
        return f.string(from: displayedMonth)
    }

    private var yearString: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy"
        return f.string(from: displayedMonth)
    }

    private let weekdaySymbols = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        ZStack {
            if style == .detail {
                // Football field background (image wider than container, fill + clip)
                Image("CalendarBg")
                    .resizable()
                    .scaledToFill()
                    .clipped()
            }

            VStack(spacing: 12) {
                header
                weekdayRow
                dayGrid
            }
            .padding(style == .detail ? 16 : 24)
        }
        .background(containerBackground)
        .cornerRadius(style == .detail ? 24 : DesignSystem.Radii.calendarContainer)
        .overlay(
            RoundedRectangle(cornerRadius: style == .detail ? 24 : DesignSystem.Radii.calendarContainer)
                .inset(by: style == .detail ? 1 : 0.5)
                .stroke(containerBorder, lineWidth: style == .detail ? 1 : 0.5)
        )
        .clipped()
    }

    private var containerBackground: Color {
        style == .detail
            ? DesignSystem.Colors.calendarDetailBg
            : DesignSystem.Colors.cardBackground
    }

    private var containerBorder: Color {
        style == .detail
            ? DesignSystem.Colors.calendarDetailBorder
            : DesignSystem.Colors.calendarContainerBorder
    }

    // Header

    @ViewBuilder
    private var header: some View {
        if style == .detail {
            detailHeader
        } else {
            creationHeader
        }
    }

    private var detailHeader: some View {
        HStack(spacing: 0) {
            Button { changeMonth(-1) } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 45)
            }

            HStack {
                Text(monthName)
                    .font(.custom(DesignSystem.Fonts.interSemiBold, size: 20))
                    .lineSpacing(24)
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)

                Spacer()

                Text(yearString)
                    .font(.custom(DesignSystem.Fonts.interRegular, size: 16))
                    .lineSpacing(24)
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)

            Button { changeMonth(1) } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 45)
            }
        }
        .frame(height: 45)
        .background(DesignSystem.calendarHeaderGradient)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .inset(by: 1)
                .stroke(.white, lineWidth: 2)
        )
    }

    private var creationHeader: some View {
        ZStack {
            HStack(spacing: 2) {
                Spacer()
                monthPill
                yearPill
                Spacer()
            }
            .padding(.horizontal, 36)

            HStack {
                Button { changeMonth(-1) } label: {
                    navArrow(left: true)
                }
                Spacer()
                Button { changeMonth(1) } label: {
                    navArrow(left: false)
                }
            }
        }
        .frame(height: 44)
    }

    private var monthPill: some View {
        Text(monthName)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
            .minimumScaleFactor(0.6)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(DesignSystem.Colors.calendarDayBg)
            .cornerRadius(6)
            .shadow(color: DesignSystem.Colors.calendarPillShadow, radius: 1, y: 1)
    }

    private var yearPill: some View {
        Text(yearString)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
            .minimumScaleFactor(0.6)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(DesignSystem.Colors.calendarDayBg)
            .cornerRadius(6)
            .shadow(color: DesignSystem.Colors.calendarPillShadow, radius: 1, y: 1)
    }

    private func navArrow(left: Bool) -> some View {
        ZStack {
            Circle()
                .fill(DesignSystem.Colors.calendarDayBg)
                .frame(width: 44, height: 44)
                .shadow(color: DesignSystem.Colors.calendarPillShadow, radius: 1, y: 1)
            Image(systemName: left ? "chevron.left" : "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    // Weekday Row

    private var weekdayRow: some View {
        HStack(spacing: 0) {
            ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { index, label in
                Text(label)
                    .font(.custom(DesignSystem.Fonts.interRegular, size: 20))
                    .lineSpacing(24)
                    .foregroundColor(weekdayColor(index: index))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
        }
    }

    private func weekdayColor(index: Int) -> Color {
        if index == 0 {
            return DesignSystem.Colors.sundayRed
        }
        return .white
    }

    // Day Grid

    private var dayGrid: some View {
        let weeks = generateWeeks()
        return VStack(spacing: style == .detail ? 6 : 4) {
            ForEach(Array(weeks.enumerated()), id: \.offset) { _, week in
                HStack(spacing: style == .detail ? 6 : 4) {
                    ForEach(week) { dayItem in
                        dayCell(dayItem)
                    }
                }
            }
        }
    }

    private func dayCell(_ item: DayItem) -> some View {
        let isSelected = item.isCurrentMonth && calendar.isDate(item.date, inSameDayAs: selectedDate)
        let isSunday = calendar.component(.weekday, from: item.date) == 1
        let hasEvent = hasEvent(for: item.date)

        return Button {
            if item.isCurrentMonth {
                selectedDate = item.date
                onDayTap?(item.date)
            }
        } label: {
            VStack(spacing: 0) {
                Text("\(calendar.component(.day, from: item.date))")
                    .font(.custom(DesignSystem.Fonts.interRegular, size: style == .detail ? 20 : 18))
                    .lineSpacing(24)
                    .foregroundColor(dayTextColor(item: item, isSelected: isSelected, isSunday: isSunday))
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(dayBackground(item: item, isSelected: isSelected))
                    .cornerRadius(DesignSystem.Radii.calendarDay)
                    .shadow(
                        color: dayShadowColor(item: item, isSelected: isSelected),
                        radius: dayShadowRadius(item: item, isSelected: isSelected),
                        y: dayShadowY(item: item, isSelected: isSelected)
                    )

                Circle()
                    .fill(hasEvent && item.isCurrentMonth ? DesignSystem.Colors.calendarEventDot : .clear)
                    .frame(width: 6, height: 6)
                    .padding(.top, 2)
            }
            .frame(height: 46)
        }
        .buttonStyle(.plain)
        .disabled(!item.isCurrentMonth)
    }

    private func dayTextColor(item: DayItem, isSelected: Bool, isSunday: Bool) -> Color {
        if isSelected {
            return style == .detail ? .white : .black
        }
        if !item.isCurrentMonth {
            return style == .detail
                ? DesignSystem.Colors.calendarFadedDetailDay
                : DesignSystem.Colors.calendarFadedDay
        }
        if isSunday && style == .detail {
            return DesignSystem.Colors.sundayRed
        }
        return style == .detail
            ? DesignSystem.Colors.calendarDetailDayText
            : .white
    }

    @ViewBuilder
    private func dayBackground(item: DayItem, isSelected: Bool) -> some View {
        if isSelected {
            DesignSystem.Colors.calendarSelectedDay
        } else if style == .detail {
            Color.white
        } else if item.isCurrentMonth {
            DesignSystem.Colors.calendarDayBg
        } else {
            Color.clear
        }
    }

    private func dayShadowColor(item: DayItem, isSelected: Bool) -> Color {
        if isSelected { return .clear }
        if style == .detail {
            return DesignSystem.Colors.calendarDetailDayShadow
        }
        return item.isCurrentMonth
            ? DesignSystem.Colors.calendarPillShadow
            : .clear
    }

    private func dayShadowRadius(item: DayItem, isSelected: Bool) -> CGFloat {
        if isSelected { return 0 }
        if style == .detail { return 2 }
        return item.isCurrentMonth ? 1 : 0
    }

    private func dayShadowY(item: DayItem, isSelected: Bool) -> CGFloat {
        if isSelected { return 0 }
        if style == .detail { return 4 }
        return item.isCurrentMonth ? 1 : 0
    }

    private func hasEvent(for date: Date) -> Bool {
        guard !eventDates.isEmpty else { return false }
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        return eventDates.contains(comps)
    }

    // Data

    private struct DayItem: Identifiable, Hashable {
        let date: Date
        let isCurrentMonth: Bool
        var id: String { "\(date.timeIntervalSince1970)_\(isCurrentMonth)" }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: DayItem, rhs: DayItem) -> Bool {
            lhs.id == rhs.id
        }
    }

    private func generateWeeks() -> [[DayItem]] {
        let comps = calendar.dateComponents([.year, .month], from: displayedMonth)
        guard let firstOfMonth = calendar.date(from: comps),
              let range = calendar.range(of: .day, in: .month, for: firstOfMonth) else {
            return []
        }

        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let padCount = (weekday - calendar.firstWeekday + 7) % 7

        var days: [DayItem] = []

        if padCount > 0 {
            for i in (1...padCount).reversed() {
                if let date = calendar.date(byAdding: .day, value: -i, to: firstOfMonth) {
                    days.append(DayItem(date: date, isCurrentMonth: false))
                }
            }
        }

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(DayItem(date: date, isCurrentMonth: true))
            }
        }

        let remainder = days.count % 7
        if remainder > 0, let lastDay = days.last?.date {
            for i in 1...(7 - remainder) {
                if let date = calendar.date(byAdding: .day, value: i, to: lastDay) {
                    days.append(DayItem(date: date, isCurrentMonth: false))
                }
            }
        }

        return stride(from: 0, to: days.count, by: 7).map {
            Array(days[$0..<min($0 + 7, days.count)])
        }
    }

    private func changeMonth(_ delta: Int) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if let newMonth = calendar.date(byAdding: .month, value: delta, to: displayedMonth) {
                displayedMonth = newMonth
            }
        }
    }
}

extension MonthCalendarView {
    func onDayTapped(_ action: @escaping @MainActor (Date) -> Void) -> MonthCalendarView {
        var copy = self
        copy.onDayTap = action
        return copy
    }
}

#Preview {
    ZStack {
        Color.black
        MonthCalendarView(selectedDate: .constant(Date()), style: .detail)
            .padding()
    }
}

