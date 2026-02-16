import SwiftUI

enum DesignSystem {

    enum Colors {
        static let backgroundDark = Color(red: 0, green: 0.03, blue: 0.12)
        static let cardBackground = Color(red: 0.05, green: 0.13, blue: 0.25)
        static let progressBarBackground = Color(red: 0.02, green: 0.05, blue: 0.15)
        static let tabBarBackground = Color(red: 0.12, green: 0.11, blue: 0.17).opacity(0.70)
        static let tabInactive = Color(red: 0.67, green: 0.67, blue: 0.67)
        static let primaryGreen = Color(red: 0.26, green: 0.91, blue: 0.17)
        static let accentGreen = Color(red: 0.25, green: 0.86, blue: 0.18)
        static let accentYellow = Color(red: 1.0, green: 0.78, blue: 0.23)
        static let gradientStart = Color(red: 0.24, green: 0.82, blue: 0.2)
        static let gradientEnd = Color(red: 0.02, green: 0.24, blue: 0.45)
        static let deleteGradientStart = Color(red: 0.95, green: 0.53, blue: 0.3)
        static let deleteGradientEnd = Color(red: 0.74, green: 0.2, blue: 0.2)
        static let editGradientStart = Color(red: 1, green: 0.78, blue: 0.23)
        static let editGradientEnd = Color(red: 1, green: 0.4, blue: 0.35)
        static let glassFrame = Color(red: 0, green: 0.03, blue: 0.12).opacity(0.8)
        static let inputBorder = Color(red: 0.54, green: 0.72, blue: 0.84)
        static let inputLabel = Color(red: 0.65, green: 0.86, blue: 0.63)
        static let inputPlaceholder = Color(red: 0.15, green: 0, blue: 0.46).opacity(0.5)
        static let cellBackground = Color.white.opacity(0.04)
        static let createButton = Color(red: 1, green: 0.88, blue: 0)

        // Calendar
        static let calendarDayBg = Color(red: 0.40, green: 0.44, blue: 0.51)
        static let calendarDayBorder = Color(red: 0.90, green: 0.90, blue: 0.90)
        static let calendarFadedDay = Color(red: 0.40, green: 1, blue: 0.98).opacity(0.15)
        static let calendarContainerBorder = Color(red: 0.26, green: 0.46, blue: 0.24)
        static let termInputBorder = Color(red: 0.26, green: 0.90, blue: 0.17)
        static let tabButtonYellow = Color(red: 1, green: 0.88, blue: 0)
        static let tabButtonGreen = Color(red: 0.24, green: 0.82, blue: 0.20)
        static let subGoalText = Color(red: 0.15, green: 0, blue: 0.46)
        static let checkboxBg = Color(red: 0.91, green: 0.91, blue: 0.91)

        // Chart
        static let chartBarDefault = Color(red: 0.17, green: 0.24, blue: 0.50).opacity(0.74)
        static let chartBarHighlight = Color(red: 0.25, green: 0.86, blue: 0.18)
        static let chartAxisText = Color(red: 0.07, green: 0, blue: 0)
        static let sundayRed = Color(red: 0.91, green: 0.06, blue: 0.08)

        // Calendar
        static let calendarSelectedDay = Color(red: 0.26, green: 0.90, blue: 0.17)
        static let calendarDetailDayText = Color(red: 0.15, green: 0, blue: 0.46)
        static let calendarFadedDetailDay = Color(red: 0.71, green: 0.66, blue: 0.80)
        static let calendarDetailDayShadow = Color(red: 0.24, green: 0, blue: 0.52, opacity: 0.35)
        static let calendarDetailBorder = Color(red: 0.25, green: 0.85, blue: 0.19)
        static let calendarDetailBg = Color(red: 0.01, green: 0.03, blue: 0.13).opacity(0.73)
        static let calendarEventDot = Color(red: 0.25, green: 0.85, blue: 0.19)
        static let calendarPillShadow = Color(red: 0, green: 0.06, blue: 0.20).opacity(0.05)
    }

    enum Fonts {
        static let interSemiBold = "Inter18pt-SemiBold"
        static let interBold = "Inter18pt-Bold"
        static let interMedium = "Inter18pt-Medium"
        static let interRegular = "Inter18pt-Regular"
        static let interThin = "Inter18pt-Thin"
        static let interLight = "Inter18pt-Light"
        static let lexendBold = "Lexend-Bold"
        static let lexendMedium = "Lexend-Medium"
    }

    enum Formatters {
        static let shortDate: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "dd.MM.yyyy"
            return f
        }()
    }

    enum Spacing {
        static let screenHorizontal: CGFloat = 20
        static let cardHorizontal: CGFloat = 16
        static let listTop: CGFloat = 38
        static let listBetween: CGFloat = 21
        static let glassTop: CGFloat = 0
        static let tabBarHeight: CGFloat = 62
        static let tabBarBottomPadding: CGFloat = 24
        static let tabBarHorizontalPadding: CGFloat = 20
        static let addGoalButtonBottomPadding: CGFloat = 130
        static let logoHeight: CGFloat = 220
        static let glassFrameWidth: CGFloat = 408
        static let glassFrameHeight: CGFloat = 956
    }

    enum Radii {
        static let card: CGFloat = 24
        static let glass: CGFloat = 18
        static let button: CGFloat = 17
        static let input: CGFloat = 16
        static let inputLarge: CGFloat = 28
        static let calendarDay: CGFloat = 6
        static let calendarContainer: CGFloat = 16
    }

    enum Swipe {
        static let goalCardRevealWidth: CGFloat = 72
        static let subGoalRevealWidth: CGFloat = 116
        static let actionButtonSize: CGFloat = 49
        static let actionButtonsSpacing: CGFloat = 8
        static let actionButtonsTrailing: CGFloat = 10
        static let openThreshold: CGFloat = 50
        static let overshootResistance: CGFloat = 0.2
        static let goalCardMinHeight: CGFloat = 131
    }

    static var primaryGradient: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Colors.gradientStart, location: 0),
                Gradient.Stop(color: Colors.gradientEnd, location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var tabBarSelectedGradient: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.26, green: 0.91, blue: 0.17), location: 0),
                Gradient.Stop(color: Color(red: 0.06, green: 0.24, blue: 0.44), location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var createButtonGradient: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 1, green: 0.88, blue: 0), location: 0),
                Gradient.Stop(color: Color(red: 1, green: 0.38, blue: 0), location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var deleteButtonGradient: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Colors.deleteGradientStart, location: 0),
                Gradient.Stop(color: Colors.deleteGradientEnd, location: 1)
            ],
            startPoint: UnitPoint(x: 0.51, y: 0.51),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }

    static var editButtonGradient: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Colors.editGradientStart, location: 0),
                Gradient.Stop(color: Colors.editGradientEnd, location: 1)
            ],
            startPoint: UnitPoint(x: 0.51, y: 0.51),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }

    static var progressBarGradient: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.24, green: 0.82, blue: 0.2), location: 0),
                Gradient.Stop(color: Color(red: 0.02, green: 0.24, blue: 0.45), location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }





    static var backgroundOverlayGradient: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.15, green: 0, blue: 0.57).opacity(0), location: 0.14),
                Gradient.Stop(color: Color(red: 0.05, green: 0, blue: 0.17), location: 0.50),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }

    static var calendarHeaderGradient: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.06, green: 0.25, blue: 0.44), location: 0),
                Gradient.Stop(color: Color(red: 0.25, green: 0.89, blue: 0.17), location: 1)
            ],
            startPoint: UnitPoint(x: 0.05, y: 0.14),
            endPoint: UnitPoint(x: 0.94, y: 0.91)
        )
    }
}

private struct CompactScreenKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isCompactScreen: Bool {
        get { self[CompactScreenKey.self] }
        set { self[CompactScreenKey.self] = newValue }
    }
}
