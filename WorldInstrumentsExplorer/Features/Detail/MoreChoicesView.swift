import SwiftUI
#if os(iOS)
import UIKit
#endif

struct MoreChoicesView: View {
    let instrument: Instrument
    @State private var showTitle = false
    @State private var showClassicButton = false
    @State private var showPartsPerformanceButton = false
    @Environment(\.dismiss) private var dismiss
    #if os(iOS)
    private var isPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    #else
    private let isPhone = false
    #endif

    var body: some View {
        GeometryReader { proxy in
            let viewportHeight = proxy.size.height
            let compactLayout = viewportHeight < 690
            let topPadding = isPhone ? 0 : max(6, min(24, viewportHeight * 0.03))
            let sidePadding = max(16, min(30, viewportHeight * 0.035))
            let buttonSpacing: CGFloat = compactLayout ? 14 : 18
            let clusterSpacing: CGFloat = compactLayout ? 24 : 34
            let clusterYOffset: CGFloat = isPhone ? 0 : (compactLayout ? -8 : -2)

            ZStack {
                RicePaperBackground()
                    .ignoresSafeArea()

                Group {
                    if isPhone {
                        ScrollView {
                            contentStack(
                                compactLayout: compactLayout,
                                topPadding: topPadding,
                                buttonSpacing: buttonSpacing,
                                clusterSpacing: clusterSpacing,
                                clusterYOffset: clusterYOffset
                            )
                            .padding(.vertical, 0)
                        }
                        .contentMargins(.vertical, 0, for: .scrollContent)
                        .contentMargins(.vertical, 0, for: .scrollIndicators)
                    } else {
                        contentStack(
                            compactLayout: compactLayout,
                            topPadding: topPadding,
                            buttonSpacing: buttonSpacing,
                            clusterSpacing: clusterSpacing,
                            clusterYOffset: clusterYOffset
                        )
                    }
                }
                .padding(.horizontal, sidePadding)
                .padding(.bottom, isPhone ? 0 : (compactLayout ? 26 : 40))
            }
        }
        .navigationTitle("More Choices")
        .overlay(alignment: .topLeading) {
            if isPhone {
                floatingBackButton
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(isPhone ? .hidden : .visible, for: .navigationBar)
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        #endif
        .onAppear {
            showTitle = false
            showClassicButton = false
            showPartsPerformanceButton = false
            showTitle = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                showClassicButton = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.27) {
                showPartsPerformanceButton = true
            }
        }
    }

    @ViewBuilder
    private func contentStack(
        compactLayout: Bool,
        topPadding: CGFloat,
        buttonSpacing: CGFloat,
        clusterSpacing: CGFloat,
        clusterYOffset: CGFloat
    ) -> some View {
        VStack(spacing: 18) {
            Spacer(minLength: isPhone ? 0 : (compactLayout ? 20 : 28))

            VStack(spacing: clusterSpacing) {
                StoneTitleLabel(
                    text: "\(instrument.nameEnglish) - More Choices",
                    compactLayout: compactLayout
                )
                .padding(.top, topPadding)
                .scaleEffect(showTitle ? 1 : 0.96)
                .opacity(showTitle ? 1 : 0)
                .animation(.easeOut(duration: 0.35), value: showTitle)

                Text("More functions will be available here soon.")
                    .font(.custom("Marker Felt", size: compactLayout ? 28 : 34))
                    .tracking(compactLayout ? 0.4 : 0.8)
                    .foregroundStyle(Color(red: 0.16, green: 0.16, blue: 0.15).opacity(0.92))
                    .overlay(
                        Text("More functions will be available here soon.")
                            .font(.custom("Marker Felt", size: compactLayout ? 28 : 34))
                            .tracking(compactLayout ? 0.4 : 0.8)
                            .foregroundStyle(Color.black.opacity(0.22))
                            .offset(x: 0.7, y: 0.8)
                            .blur(radius: 0.35)
                    )
                    .shadow(color: Color.black.opacity(0.25), radius: 0.6, x: 0.4, y: 0.8)
                    .multilineTextAlignment(.center)
                    .lineSpacing(compactLayout ? 4 : 6)
                    .padding(.horizontal, compactLayout ? 22 : 30)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeOut(duration: 0.32).delay(0.06), value: showTitle)

                VStack(spacing: buttonSpacing) {
                    NavigationLink {
                        ClassicPiecesGalleryView(instrument: instrument)
                    } label: {
                        BrushTextButtonLabel(
                            text: "Classic Pieces",
                            systemIcon: "music.note",
                            accent: Color(red: 0.40, green: 0.28, blue: 0.13)
                        )
                    }
                    .buttonStyle(ChoicePressFeedbackStyle())
                    .accessibilityLabel("Classic Pieces")
                    .accessibilityHint("Browse classic works for this instrument.")
                    .scaleEffect(showClassicButton ? 1 : 0.97)
                    .opacity(showClassicButton ? 1 : 0)
                    .offset(y: showClassicButton ? 0 : 10)
                    .animation(.easeOut(duration: 0.32), value: showClassicButton)

                    NavigationLink {
                        PartsAndPerformanceView(instrument: instrument)
                    } label: {
                        BrushTextButtonLabel(
                            text: "Parts & Performance",
                            systemIcon: "person.fill",
                            accent: Color(red: 0.46, green: 0.19, blue: 0.12)
                        )
                    }
                    .buttonStyle(ChoicePressFeedbackStyle())
                    .accessibilityLabel("Parts and Performance")
                    .accessibilityHint("View instrument parts and playing posture examples.")
                    .scaleEffect(showPartsPerformanceButton ? 1 : 0.97)
                    .opacity(showPartsPerformanceButton ? 1 : 0)
                    .offset(y: showPartsPerformanceButton ? 0 : 10)
                    .animation(.easeOut(duration: 0.32), value: showPartsPerformanceButton)
                }
                .padding(.top, compactLayout ? 10 : 16)
            }
            .frame(maxWidth: 760)
            .offset(y: clusterYOffset)

            Spacer(minLength: isPhone ? 0 : (compactLayout ? 20 : 32))
        }
    }

    @ViewBuilder
    private var floatingBackButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.black.opacity(0.88))
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial, in: Circle())
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.14), lineWidth: 0.8)
                )
        }
        .buttonStyle(.plain)
        .padding(.leading, 16)
        .padding(.top, 8)
    }
}

private struct StoneTitleLabel: View {
    let text: String
    let compactLayout: Bool

    var body: some View {
        Text(text)
            .font(.custom("Copperplate-Bold", size: compactLayout ? 34 : 41))
            .foregroundStyle(.black.opacity(0.82))
            .padding(.horizontal, compactLayout ? 28 : 42)
            .padding(.vertical, compactLayout ? 18 : 26)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.76, green: 0.76, blue: 0.72),
                        Color(red: 0.56, green: 0.56, blue: 0.52)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: SteppingStoneTitleShape()
            )
            .overlay(
                SteppingStoneTitleShape()
                    .stroke(Color.black.opacity(0.28), lineWidth: 1.2)
            )
            .shadow(color: .black.opacity(0.24), radius: 5, x: 0, y: 3)
    }
}

private struct BrushTextButtonLabel: View {
    let text: String
    let systemIcon: String
    let accent: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemIcon)
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(accent.opacity(0.85))

            Text(text)
                .font(.custom("Snell Roundhand Black", size: 42))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .foregroundStyle(Color.black.opacity(0.86))
        }
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity)
        .frame(height: 90)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.97, green: 0.95, blue: 0.88),
                            Color(red: 0.90, green: 0.87, blue: 0.79)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.black.opacity(0.22), lineWidth: 1.1)

                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(accent.opacity(0.22), lineWidth: 1.6)
                    .padding(4)

                // Rice paper fibers.
                VStack(spacing: 6) {
                    ForEach(0..<8, id: \.self) { i in
                        Capsule()
                            .fill(Color.black.opacity(i.isMultiple(of: 2) ? 0.05 : 0.03))
                            .frame(height: 1)
                    }
                }
                .padding(.horizontal, 16)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        )
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
    }
}

private struct RicePaperBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.94, blue: 0.77),
                    Color(red: 0.93, green: 0.86, blue: 0.62)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            ForEach(0..<30, id: \.self) { i in
                Circle()
                    .fill(Color(red: 0.28, green: 0.21, blue: 0.11).opacity(i.isMultiple(of: 2) ? 0.028 : 0.016))
                    .frame(width: CGFloat(36 + (i * 7 % 48)), height: CGFloat(20 + (i * 11 % 42)))
                    .position(
                        x: CGFloat(20 + (i * 37 % 340)),
                        y: CGFloat(30 + (i * 71 % 700))
                    )
            }

            Capsule()
                .fill(Color(red: 0.30, green: 0.22, blue: 0.10).opacity(0.09))
                .frame(width: 260, height: 18)
                .rotationEffect(.degrees(-14))
                .offset(x: -110, y: -170)

            Capsule()
                .fill(Color(red: 0.30, green: 0.22, blue: 0.10).opacity(0.07))
                .frame(width: 230, height: 16)
                .rotationEffect(.degrees(12))
                .offset(x: 120, y: 210)

            LinearGradient(
                colors: [
                    Color.black.opacity(0.16),
                    Color.clear,
                    Color.black.opacity(0.18)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .blendMode(.multiply)
        }
    }
}

private struct ChoicePressFeedbackStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .brightness(configuration.isPressed ? -0.04 : 0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

private struct SteppingStoneTitleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: 0.08 * w, y: 0.18 * h))
        p.addLine(to: CGPoint(x: 0.85 * w, y: 0.08 * h))
        p.addLine(to: CGPoint(x: 0.97 * w, y: 0.36 * h))
        p.addLine(to: CGPoint(x: 0.91 * w, y: 0.80 * h))
        p.addLine(to: CGPoint(x: 0.63 * w, y: 0.94 * h))
        p.addLine(to: CGPoint(x: 0.18 * w, y: 0.88 * h))
        p.addLine(to: CGPoint(x: 0.03 * w, y: 0.55 * h))
        p.closeSubpath()
        return p
    }
}
