import SwiftUI
#if os(iOS)
import UIKit
#endif

struct ExploreView: View {
    private struct VerseEntry {
        let poemEnglish: String
        let poemOriginal: String?
    }

    private let instruments = SampleData.instruments
    private let mapAspectRatio: CGFloat = 4977.0 / 2515.0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dismiss) private var dismiss
    @State private var activeInstrumentID: String?
    @State private var showMapIntro = false
    #if os(iOS)
    private var isPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    #else
    private let isPhone = false
    #endif

    var body: some View {
        GeometryReader { proxy in
            let mapFrame = fittedMapFrame(in: proxy.size)

            ZStack {
                Color.white.ignoresSafeArea()

                Image("world_map")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .accessibilityHidden(true)
                    .scaleEffect(showMapIntro ? 1 : 1.02)
                    .opacity(showMapIntro ? 1 : 0.95)

                Color.black.opacity(0.08)
                    .ignoresSafeArea()

                ForEach(instruments) { instrument in
                    let point = markerPoint(for: instrument.id, in: mapFrame)
                    let offset = tagOffset(for: instrument.id)
                    let tagCenter = CGPoint(x: point.x + offset.width, y: point.y + offset.height)

                    ZStack {
                        Circle()
                            .stroke(Color.black, lineWidth: 2)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(Color.black)
                            .frame(width: 4, height: 4)
                    }
                    .accessibilityHidden(true)
                    .position(x: point.x, y: point.y)
                    .scaleEffect(showMapIntro ? 1 : 0.88)
                    .opacity(showMapIntro ? 1 : 0)
                    .animation(
                        reduceMotion ? nil : .easeOut(duration: 0.3)
                            .delay(Double(instrument.id.hashValue.magnitude % 5) * 0.04),
                        value: showMapIntro
                    )

                    Button {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
                            activeInstrumentID = instrument.id
                        }
                    } label: {
                        Text(instrument.nameEnglish)
                            .font(.custom("Marker Felt", size: 18))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .frame(minWidth: 44, minHeight: 44)
                            .foregroundStyle(.black.opacity(0.9))
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.76, green: 0.57, blue: 0.35),
                                    Color(red: 0.67, green: 0.49, blue: 0.28)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color(red: 0.34, green: 0.22, blue: 0.12), lineWidth: 1.2)
                        )
                        .shadow(color: .black.opacity(0.22), radius: 2, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Select \(instrument.nameEnglish)")
                    .accessibilityHint("Open details and options for this instrument.")
                    .accessibilityValue(activeInstrumentID == instrument.id ? "Selected" : "Not selected")
                    .position(
                        x: tagCenter.x,
                        y: tagCenter.y
                    )
                    .scaleEffect(showMapIntro ? 1 : 0.9)
                    .opacity(showMapIntro ? 1 : 0)
                    .animation(
                        reduceMotion ? nil : .easeOut(duration: 0.36)
                            .delay(Double(instrument.id.hashValue.magnitude % 6) * 0.05),
                        value: showMapIntro
                    )
                }

                if activeInstrument != nil {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .accessibilityHidden(true)
                        .onTapGesture {
                            if reduceMotion {
                                activeInstrumentID = nil
                            } else {
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
                                    activeInstrumentID = nil
                                }
                            }
                        }
                        .transition(.opacity)
                }

                if let active = activeInstrument {
                    instrumentPopup(for: active)
                        .padding(.horizontal, 20)
                        .transition(
                            .asymmetric(
                                insertion: .scale(scale: 0.93)
                                    .combined(with: .opacity)
                                    .combined(with: .offset(y: 18)),
                                removal: .scale(scale: 0.98)
                                    .combined(with: .opacity)
                            )
                        )
                }
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            if isPhone {
                floatingBackButton
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(isPhone ? .hidden : .visible, for: .navigationBar)
        #endif
        .animation(reduceMotion ? nil : .spring(response: 0.44, dampingFraction: 0.8), value: activeInstrumentID)
        .onAppear {
            showMapIntro = false
            if reduceMotion {
                showMapIntro = true
            } else {
                withAnimation(.easeOut(duration: 0.38)) {
                    showMapIntro = true
                }
            }
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
        .accessibilityLabel("Back")
        .accessibilityHint("Return to the main menu.")
        .padding(.leading, 16)
        .padding(.top, 8)
    }

    private func fittedMapFrame(in container: CGSize) -> CGRect {
        let widthByHeight = container.height * mapAspectRatio
        let fittedWidth = min(container.width, widthByHeight)
        let fittedHeight = fittedWidth / mapAspectRatio
        let x = (container.width - fittedWidth) / 2
        let y = (container.height - fittedHeight) / 2
        return CGRect(x: x, y: y, width: fittedWidth, height: fittedHeight)
    }

    private func markerPoint(for id: String, in frame: CGRect) -> CGPoint {
        let normalized = normalizedMarkerPosition(for: id)
        return CGPoint(
            x: frame.minX + frame.width * normalized.x,
            y: frame.minY + frame.height * normalized.y
        )
    }

    //Do NOT change any value in this function
    private func normalizedMarkerPosition(for id: String) -> CGPoint {
        switch id {
        case "guqin":
            return CGPoint(x: 0.757, y: 0.283) // Luoyang
        case "pipa":
            return CGPoint(x: 0.740, y: 0.275) // Xi'an
        case "koto":
            return CGPoint(x: 0.828, y: 0.287) // Nara
        case "oud":
            return CGPoint(x: 0.588, y: 0.294) // Baghdad
        case "kora":
            return CGPoint(x: 0.428, y: 0.415) // Banjul
        default:
            return CGPoint(x: 0.5, y: 0.5)
        }
    }

    private func tagOffset(for id: String) -> CGSize {
        switch id {
        case "guqin":
            return CGSize(width: 44, height: -20)
        case "pipa":
            return CGSize(width: -42, height: -16)
        case "koto":
            return CGSize(width: 52, height: -8)
        case "oud":
            return CGSize(width: -46, height: 0)
        case "kora":
            return CGSize(width: -48, height: 10)
        default:
            return CGSize(width: 36, height: -18)
        }
    }

    private var activeInstrument: Instrument? {
        guard let id = activeInstrumentID else { return nil }
        return instruments.first(where: { $0.id == id })
    }

    @ViewBuilder
    private func instrumentPopup(for instrument: Instrument) -> some View {
        let verse = verseEntry(for: instrument.id)

        VStack(spacing: 14) {
            HStack {
                woodNameplate(text: instrument.nameEnglish)
                Spacer()
                Button {
                    if reduceMotion {
                        activeInstrumentID = nil
                    } else {
                        withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
                            activeInstrumentID = nil
                        }
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.black.opacity(0.45))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close details")
                .accessibilityHint("Dismiss the instrument details panel.")
            }

            bambooSlip(
                text: oneSentence(instrument.cultureSummary),
                width: 0.88,
                font: .custom("Times New Roman", size: 29)
            )

            bambooSlip(
                text: verse.poemEnglish,
                width: 0.78,
                font: .custom("Palatino-Italic", size: 24),
                textAlignment: .center
            )

            if let original = verse.poemOriginal {
                bambooSlip(
                    text: original,
                    width: 0.72,
                    font: originalPoemFont(for: instrument.id),
                    textAlignment: .center
                )
            }

            NavigationLink {
                MoreChoicesView(instrument: instrument)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.right")
                        .font(.headline.weight(.bold))
                    Text("More Choices")
                        .font(.custom("Copperplate-Bold", size: 24))
                }
                .foregroundStyle(.black.opacity(0.82))
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.76, green: 0.76, blue: 0.72), Color(red: 0.56, green: 0.56, blue: 0.52)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: SteppingStoneShape()
                )
                .overlay(
                    SteppingStoneShape()
                        .stroke(Color.black.opacity(0.28), lineWidth: 1.2)
                )
                .shadow(color: .black.opacity(0.24), radius: 5, x: 0, y: 3)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("More choices")
            .accessibilityHint("Open classic pieces and parts or performance pages.")
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(18)
        .frame(maxWidth: 860)
    }

    @ViewBuilder
    private func woodNameplate(text: String) -> some View {
        Text(text)
            .font(.custom("Marker Felt", size: 34))
            .foregroundStyle(.black.opacity(0.88))
            .padding(.horizontal, 22)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.82, green: 0.63, blue: 0.39), Color(red: 0.66, green: 0.47, blue: 0.25)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 14, style: .continuous)
            )
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color(red: 0.35, green: 0.22, blue: 0.12), lineWidth: 1.4)
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(.white.opacity(0.22), lineWidth: 1)
                        .padding(1.5)
                    // subtle wood grain
                    VStack(spacing: 4) {
                        ForEach(0..<7, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.black.opacity(0.06))
                                .frame(height: 1)
                        }
                    }
                    .padding(.horizontal, 10)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            )
            .shadow(color: .black.opacity(0.24), radius: 5, x: 0, y: 3)
    }

    @ViewBuilder
    private func bambooSlip(
        text: String,
        width: CGFloat,
        font: Font = .custom("Palatino-Italic", size: 24),
        textAlignment: TextAlignment = .leading
    ) -> some View {
        HStack {
            Text(text)
                .font(font)
                .multilineTextAlignment(textAlignment)
                .foregroundStyle(.black.opacity(0.9))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(
                    maxWidth: .infinity,
                    alignment: textAlignment == .center ? .center : .leading
                )
        }
        .frame(maxWidth: 860 * width)
        .background(
            LinearGradient(
                colors: [Color(red: 0.90, green: 0.80, blue: 0.58), Color(red: 0.78, green: 0.66, blue: 0.43)],
                startPoint: .top,
                endPoint: .bottom
            ),
            in: BambooSlipShape()
        )
        .overlay(
            ZStack {
                BambooSlipShape()
                    .stroke(Color(red: 0.40, green: 0.28, blue: 0.15), lineWidth: 1.2)
                // bamboo joints
                HStack(spacing: 0) {
                    ForEach(0..<4, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.black.opacity(0.08))
                            .frame(width: 2)
                            .frame(maxHeight: .infinity)
                        Spacer(minLength: 0)
                    }
                }
                .padding(.horizontal, 26)
                .clipShape(BambooSlipShape())
                // highlight strip
                VStack {
                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .frame(height: 3)
                    Spacer()
                }
                .clipShape(BambooSlipShape())
            }
        )
        .shadow(color: .black.opacity(0.18), radius: 4, x: 0, y: 2)
    }

    private func oneSentence(_ text: String) -> String {
        if let range = text.range(of: ".") {
            return String(text[..<range.upperBound])
        }
        return text
    }

    private func verseEntry(for id: String) -> VerseEntry {
        switch id {
        case "guqin":
            return VerseEntry(
                poemEnglish: "Sitting alone in dense bamboo grove; I play zither (guqin) and also chant out loud.",
                poemOriginal: "独坐幽篁里，弹琴复长啸。"
            )
        case "pipa":
            return VerseEntry(
                poemEnglish: "Thick strings clatter like splattering rain; fine strings murmur like whispered words.",
                poemOriginal: "大弦嘈嘈如急雨，小弦切切如私语。"
            )
        case "koto":
            return VerseEntry(
                poemEnglish: "To the sound of koto, pine-wind answers from the mountain peak.",
                poemOriginal: "琴の音に峰の松風かよふらし／いづれのをよりしらべそめけむ"
            )
        case "oud":
            return VerseEntry(
                poemEnglish: "In the night gathering, the oud begins, and the heart follows its low flame.",
                poemOriginal: "فأخذت الجارية العود وأصلحته، وشدت أوتاره"
            )
        case "kora":
            return VerseEntry(
                poemEnglish: "However long the night, the dawn will break.",
                poemOriginal: nil
            )
        default:
            return VerseEntry(
                poemEnglish: "Its voice lingers, turning distance into song.",
                poemOriginal: nil
            )
        }
    }

    private func originalPoemFont(for id: String) -> Font {
        switch id {
        case "guqin", "pipa":
            return .custom("STKaiti", size: 26)
        case "koto":
            return .custom("Hiragino Mincho ProN", size: 24)
        case "oud":
            return .custom("Geeza Pro", size: 24)
        default:
            return .custom("Palatino-Italic", size: 24)
        }
    }
}

private struct BambooSlipShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cut: CGFloat = min(rect.width, rect.height) * 0.08
        let left = rect.minX
        let right = rect.maxX
        let top = rect.minY
        let bottom = rect.maxY

        p.move(to: CGPoint(x: left + cut, y: top))
        p.addLine(to: CGPoint(x: right - cut * 1.0, y: top))
        p.addLine(to: CGPoint(x: right - cut * 0.2, y: top + cut * 0.4))
        p.addLine(to: CGPoint(x: right, y: top + cut * 1.0))
        p.addLine(to: CGPoint(x: right - cut * 0.3, y: top + cut * 1.6))
        p.addLine(to: CGPoint(x: right, y: top + cut * 2.3))
        p.addLine(to: CGPoint(x: right - cut * 0.2, y: top + cut * 3.0))
        p.addLine(to: CGPoint(x: right, y: bottom - cut * 3.0))
        p.addLine(to: CGPoint(x: right - cut * 0.4, y: bottom - cut * 2.3))
        p.addLine(to: CGPoint(x: right, y: bottom - cut * 1.6))
        p.addLine(to: CGPoint(x: right - cut * 0.2, y: bottom - cut * 0.8))
        p.addLine(to: CGPoint(x: right - cut, y: bottom))
        p.addLine(to: CGPoint(x: left + cut * 1.1, y: bottom))
        p.addLine(to: CGPoint(x: left + cut * 0.3, y: bottom - cut * 0.4))
        p.addLine(to: CGPoint(x: left, y: bottom - cut * 1.0))
        p.addLine(to: CGPoint(x: left + cut * 0.5, y: bottom - cut * 1.7))
        p.addLine(to: CGPoint(x: left, y: bottom - cut * 2.4))
        p.addLine(to: CGPoint(x: left + cut * 0.4, y: bottom - cut * 3.1))
        p.addLine(to: CGPoint(x: left, y: top + cut * 3.0))
        p.addLine(to: CGPoint(x: left + cut * 0.5, y: top + cut * 2.1))
        p.addLine(to: CGPoint(x: left, y: top + cut * 1.3))
        p.addLine(to: CGPoint(x: left + cut * 0.4, y: top + cut * 0.6))
        p.closeSubpath()
        return p
    }
}

private struct SteppingStoneShape: Shape {
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
//
//  ExploreView.swift
//  WorldInstrumentsExplorer
//
//  Created by zhengbei on 2026/2/9.
//
