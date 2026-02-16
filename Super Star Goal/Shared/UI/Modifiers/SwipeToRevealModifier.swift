import SwiftUI

enum SwipeOrientation {
    case horizontal
    case vertical
}

struct SwipeToRevealModifier: ViewModifier {
    let revealWidth: CGFloat
    let orientation: SwipeOrientation
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onTapped: () -> Void

    @State private var revealedWidth: CGFloat = 0
    @State private var isSwiped: Bool = false

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onChanged { value in
                guard abs(value.translation.width) > abs(value.translation.height) else { return }
                if value.translation.width < 0 {
                    let translation = value.translation.width
                    let target = min(-translation, revealWidth)
                    let extra = max(0, -translation - revealWidth)
                    revealedWidth = target + extra * DesignSystem.Swipe.overshootResistance
                } else if value.translation.width > 0 && isSwiped {
                    revealedWidth = max(0, revealWidth - value.translation.width)
                }
            }
            .onEnded { value in
                withAnimation(.spring()) {
                    if value.translation.width < -DesignSystem.Swipe.openThreshold {
                        revealedWidth = revealWidth
                        isSwiped = true
                    } else {
                        revealedWidth = 0
                        isSwiped = false
                    }
                }
            }
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            // Action Buttons (Background)
            Group {
                if orientation == .vertical {
                    VStack(spacing: DesignSystem.Swipe.actionButtonsSpacing) {
                        actionButtons
                    }
                } else {
                    HStack(spacing: DesignSystem.Swipe.actionButtonsSpacing) {
                        actionButtons
                    }
                }
            }
            .padding(.trailing, DesignSystem.Swipe.actionButtonsTrailing)
            .zIndex(0)

            // Content (Foreground)
            HStack(spacing: 0) {
                content
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isSwiped {
                            withAnimation(.spring()) {
                                revealedWidth = 0
                                isSwiped = false
                            }
                        } else {
                            onTapped()
                        }
                    }
                    .simultaneousGesture(swipeGesture)
                
                Spacer(minLength: 0)
                    .frame(width: revealedWidth)
            }
            .zIndex(1)
        }
    }

    @ViewBuilder
    private var actionButtons: some View {
        Button(action: {
            withAnimation { revealedWidth = 0; isSwiped = false }
             Task { @MainActor in
                try? await Task.sleep(nanoseconds: 100_000_000)
                onDelete()
            }
        }) {
            ZStack {
                Circle()
                    .fill(DesignSystem.deleteButtonGradient)
                    .frame(width: DesignSystem.Swipe.actionButtonSize, height: DesignSystem.Swipe.actionButtonSize)
                Image(systemName: "trash")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(.plain)

        Button(action: {
            withAnimation { revealedWidth = 0; isSwiped = false }
            onEdit()
        }) {
            ZStack {
                Circle()
                    .fill(DesignSystem.editButtonGradient)
                    .frame(width: DesignSystem.Swipe.actionButtonSize, height: DesignSystem.Swipe.actionButtonSize)
                Image("IconPencil")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(.plain)
    }
}

extension View {
    func swipeToReveal(
        revealWidth: CGFloat,
        orientation: SwipeOrientation = .horizontal,
        onEdit: @escaping () -> Void,
        onDelete: @escaping () -> Void,
        onTapped: @escaping () -> Void
    ) -> some View {
        modifier(SwipeToRevealModifier(
            revealWidth: revealWidth,
            orientation: orientation,
            onEdit: onEdit,
            onDelete: onDelete,
            onTapped: onTapped
        ))
    }
}
