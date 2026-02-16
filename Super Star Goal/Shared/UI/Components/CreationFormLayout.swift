import SwiftUI

struct CreationFormLayout: View {
    @Binding var title: String
    @Binding var date: Date
    @Binding var showCalendar: Bool
    
    let isEditMode: Bool
    let placeholder: String
    let onSave: () -> Void

    @FocusState private var isNameFocused: Bool

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                previewCard
                    .padding(.bottom, 51)

                nameSection
                    .padding(.bottom, 14)

                termSection

                if showCalendar {
                    MonthCalendarView(selectedDate: $date, style: .creation)
                        .padding(.top, 14)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                createButton
                    .padding(.top, 51)
            }
            .padding(.horizontal, 38)
            .padding(.bottom, 40)
        }
        .onTapGesture { isNameFocused = false }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isNameFocused = false }
                    .font(.custom(DesignSystem.Fonts.interSemiBold, size: 16))
                    .foregroundColor(DesignSystem.Colors.accentGreen)
            }
        }
    }

    private var previewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 7) {
                Text(title.isEmpty ? "Name" : title)
                    .font(.custom(DesignSystem.Fonts.interRegular, size: 16))
                    .lineSpacing(12)
                    .foregroundColor(.white)
                Text("Status: ")
                    .font(.custom(DesignSystem.Fonts.interThin, size: 14))
                    .lineSpacing(12)
                    .foregroundColor(.white)
            }

            Capsule()
                .fill(DesignSystem.Colors.progressBarBackground)
                .frame(height: 21)
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 131, alignment: .leading)
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(DesignSystem.Radii.card)
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name")
                .font(.custom(DesignSystem.Fonts.interSemiBold, size: 17))
                .foregroundColor(DesignSystem.Colors.inputLabel)

            HStack {
                ZStack(alignment: .leading) {
                    if title.isEmpty {
                        Text(placeholder)
                            .font(.custom(DesignSystem.Fonts.interSemiBold, size: 20))
                            .foregroundColor(DesignSystem.Colors.inputPlaceholder)
                    }
                    TextField("", text: $title)
                        .font(.custom(DesignSystem.Fonts.interSemiBold, size: 20))
                        .foregroundColor(DesignSystem.Colors.subGoalText)
                        .focused($isNameFocused)
                        .submitLabel(.done)
                        .onSubmit { isNameFocused = false }
                }

                Image("IconPencil")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(DesignSystem.Colors.inputPlaceholder)
            }
            .padding(16)
            .background(.white)
            .cornerRadius(DesignSystem.Radii.input)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radii.input)
                    .inset(by: 1)
                    .stroke(DesignSystem.Colors.inputBorder, lineWidth: 1)
            )
        }
    }

    private var termSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Term")
                .font(.custom(DesignSystem.Fonts.interSemiBold, size: 17))
                .foregroundColor(DesignSystem.Colors.inputLabel)

            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showCalendar.toggle()
                }
            }) {
                HStack {
                    Text(DesignSystem.Formatters.shortDate.string(from: date))
                        .font(.custom(DesignSystem.Fonts.interSemiBold, size: 20))
                        .foregroundColor(DesignSystem.Colors.inputPlaceholder)

                    Spacer()

                    Image(showCalendar ? "IconChevronUp" : "IconChevronDown")
                }
                .padding(16)
                .background(.white)
                .cornerRadius(DesignSystem.Radii.input)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Radii.input)
                        .inset(by: 1)
                        .stroke(DesignSystem.Colors.inputBorder, lineWidth: 1)
                )
            }
        }
    }

    private var createButton: some View {
        Button(action: onSave) {
            Text(isEditMode ? "Save" : "Create")
                .font(.custom(DesignSystem.Fonts.interSemiBold, size: 17))
                .foregroundColor(.black)
                .frame(width: 166, height: 34)
                .background(DesignSystem.createButtonGradient)
                .cornerRadius(DesignSystem.Radii.button)
        }
    }
}
