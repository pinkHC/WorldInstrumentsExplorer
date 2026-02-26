import SwiftUI
import AVFAudio
import Combine
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

struct ClassicPiecesGalleryView: View {
    let instrument: Instrument

    @State private var visibleCardCount = 0
    @StateObject private var audioController = PieceAudioController()
    private let cardWidth: CGFloat = 230
    private let cardSpacing: CGFloat = 18

    var body: some View {
        GeometryReader { geo in
            let rows = wrappedRows(for: geo.size.width)

            ScrollView {
                VStack(spacing: 24) {
                    ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                        let rowCardCount = row.count
                        let rowWidth = hangingRowWidth(cardCount: rowCardCount)

                        VStack(spacing: 8) {
                            HangingStringView()
                                .frame(height: 54)
                                .frame(width: rowWidth + 10)

                            HStack(alignment: .top, spacing: cardSpacing) {
                                ForEach(row, id: \.piece.id) { item in
                                    let playable = isPlayable(item.piece)
                                    HangingPieceCard(
                                        piece: item.piece,
                                        isPlayable: playable,
                                        isPlaying: audioController.playingPieceID == item.piece.id,
                                        onTap: {
                                            guard playable else { return }
                                            audioController.togglePlayback(for: item.piece)
                                        },
                                        tiltAngle: cardTilt(index: item.index)
                                    )
                                    .frame(width: cardWidth)
                                    .scaleEffect(item.index < visibleCardCount ? 1 : 0.72)
                                    .opacity(item.index < visibleCardCount ? 1 : 0)
                                    .offset(y: item.index < visibleCardCount ? 0 : 14)
                                    .animation(
                                        .spring(response: 0.42, dampingFraction: 0.72)
                                            .delay(Double(item.index) * 0.08),
                                        value: visibleCardCount
                                    )
                                }
                            }
                            .frame(width: rowWidth)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }

                    Text("Thank you for using INSTRUMENT ATLAS!")
                        .font(.custom("Palatino-Italic", size: 18))
                        .foregroundStyle(Color.black.opacity(0.72))
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
        }
        .safeAreaPadding(.top, 8)
        .safeAreaPadding(.bottom, 8)
        .background(OldPaperGalleryBackground())
        .navigationTitle("Classic Pieces")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            visibleCardCount = 0
            for index in instrument.classicPieces.indices {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                    visibleCardCount = max(visibleCardCount, index + 1)
                }
            }
        }
        .onDisappear {
            audioController.stop()
        }
    }

    private struct IndexedPiece {
        let index: Int
        let piece: ClassicPiece
    }

    private func wrappedRows(for totalWidth: CGFloat) -> [[IndexedPiece]] {
        let contentWidth = max(220, totalWidth - 32)
        let rawCount = (contentWidth + cardSpacing) / (cardWidth + cardSpacing)
        let cardsPerRow = max(1, Int(rawCount))
        let indexed = instrument.classicPieces.enumerated().map { IndexedPiece(index: $0.offset, piece: $0.element) }
        var rows: [[IndexedPiece]] = []
        var start = 0
        while start < indexed.count {
            let end = min(start + cardsPerRow, indexed.count)
            rows.append(Array(indexed[start..<end]))
            start = end
        }
        return rows
    }

    private func hangingRowWidth(cardCount: Int) -> CGFloat {
        guard cardCount > 0 else { return cardWidth }
        return CGFloat(cardCount) * cardWidth + CGFloat(cardCount - 1) * cardSpacing
    }

    private func cardTilt(index: Int) -> Double {
        let pattern: [Double] = [-3.0, 2.2, -1.4, 3.1]
        return pattern[index % pattern.count]
    }

    private func isPlayable(_ piece: ClassicPiece) -> Bool {
        AudioResourceLocator.url(for: piece.audioFile) != nil
    }
}

private struct OldPaperGalleryBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.97, green: 0.93, blue: 0.77),
                    Color(red: 0.91, green: 0.84, blue: 0.62)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            ForEach(0..<34, id: \.self) { i in
                Circle()
                    .fill(Color(red: 0.29, green: 0.20, blue: 0.11).opacity(i.isMultiple(of: 2) ? 0.024 : 0.014))
                    .frame(width: CGFloat(28 + (i * 11 % 52)), height: CGFloat(16 + (i * 13 % 42)))
                    .position(
                        x: CGFloat(20 + (i * 37 % 360)),
                        y: CGFloat(20 + (i * 71 % 760))
                    )
            }

            Capsule()
                .fill(Color(red: 0.30, green: 0.22, blue: 0.10).opacity(0.08))
                .frame(width: 250, height: 18)
                .rotationEffect(.degrees(-13))
                .offset(x: -100, y: -210)

            Capsule()
                .fill(Color(red: 0.30, green: 0.22, blue: 0.10).opacity(0.07))
                .frame(width: 220, height: 16)
                .rotationEffect(.degrees(10))
                .offset(x: 110, y: 240)

            LinearGradient(
                colors: [
                    Color.black.opacity(0.15),
                    Color.clear,
                    Color.black.opacity(0.16)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .blendMode(.multiply)
        }
    }
}

private struct HangingStringView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Path { p in
                    p.move(to: CGPoint(x: 0, y: 14))
                    p.addCurve(
                        to: CGPoint(x: geo.size.width, y: 14),
                        control1: CGPoint(x: geo.size.width * 0.3, y: 3),
                        control2: CGPoint(x: geo.size.width * 0.7, y: 24)
                    )
                }
                .stroke(Color.black.opacity(0.5), lineWidth: 2)

                HStack(spacing: 36) {
                    ForEach(0..<7, id: \.self) { _ in
                        Circle()
                            .fill(Color(red: 0.56, green: 0.34, blue: 0.18))
                            .frame(width: 8, height: 8)
                    }
                }
                .frame(maxWidth: .infinity)
                .offset(y: 14)
            }
        }
    }
}

private struct HangingPieceCard: View {
    let piece: ClassicPiece
    let isPlayable: Bool
    let isPlaying: Bool
    let onTap: () -> Void
    let tiltAngle: Double

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.black.opacity(0.55))
                    .frame(width: 2, height: 22)

                VStack(spacing: 10) {
                    PiecePhotoArtwork(pieceID: piece.id, useGrayscale: !isPlayable)
                        .frame(height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                    Text(piece.title)
                        .font(.custom("Times New Roman", size: 22))
                        .foregroundStyle(Color.black.opacity(0.88))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity)

                    Image(systemName: playbackIcon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(playbackColor)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white.opacity(0.95))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.black.opacity(0.22), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 3)
            }
        }
        .buttonStyle(.plain)
        .disabled(!isPlayable)
        .rotationEffect(.degrees(tiltAngle))
    }

    private var playbackIcon: String {
        guard isPlayable else { return "speaker.slash.fill" }
        return isPlaying ? "pause.circle.fill" : "play.circle.fill"
    }

    private var playbackColor: Color {
        if !isPlayable {
            return Color.gray.opacity(0.8)
        }
        return isPlaying ? Color(red: 0.74, green: 0.20, blue: 0.14) : Color(red: 0.14, green: 0.30, blue: 0.60)
    }
}

private enum AudioResourceLocator {
    private static let supportedExtensions: Set<String> = ["mp3", "m4a", "wav", "aac", "aif", "aiff", "caf"]

    static func url(for audioFile: String) -> URL? {
        let filename = audioFile as NSString
        let ext = filename.pathExtension.lowercased()
        guard supportedExtensions.contains(ext) else { return nil }

        if audioFile.contains("/") {
            let path = audioFile as NSString
            let subdirectory = path.deletingLastPathComponent
            let resource = (path.lastPathComponent as NSString).deletingPathExtension
            if let nestedURL = Bundle.main.url(
                forResource: resource,
                withExtension: ext,
                subdirectory: subdirectory == "." ? nil : subdirectory
            ) {
                return nestedURL
            }
        }

        let resource = filename.deletingPathExtension
        let candidateSubdirectories: [String?] = [nil, "audio", "Audio", "context/audio", "Resources/Audio"]
        for subdirectory in candidateSubdirectories {
            if let bundledURL = Bundle.main.url(forResource: resource, withExtension: ext, subdirectory: subdirectory) {
                return bundledURL
            }
        }

        return nil
    }
}

private final class PieceAudioController: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published private(set) var playingPieceID: String?
    private var player: AVAudioPlayer?

    func togglePlayback(for piece: ClassicPiece) {
        guard let url = AudioResourceLocator.url(for: piece.audioFile) else {
            stop()
            return
        }

        if playingPieceID == piece.id, player?.isPlaying == true {
            stop()
            return
        }

        play(url: url, pieceID: piece.id)
    }

    func stop() {
        player?.stop()
        player = nil
        playingPieceID = nil
    }

    private func play(url: URL, pieceID: String) {
        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.delegate = self
            newPlayer.prepareToPlay()
            newPlayer.play()
            player = newPlayer
            playingPieceID = pieceID
        } catch {
            stop()
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
    }
}

private struct PiecePhotoArtwork: View {
    let pieceID: String
    let useGrayscale: Bool

    private var hasLocalImage: Bool {
        #if os(iOS)
        return UIImage(named: pieceID) != nil
        #elseif os(macOS)
        return NSImage(named: pieceID) != nil
        #else
        return false
        #endif
    }

    var body: some View {
        Group {
            if hasLocalImage {
                Image(pieceID)
                    .resizable()
                    .scaledToFill()
            } else {
                GeneratedPieceArtwork(seedSource: pieceID, useGrayscale: useGrayscale)
            }
        }
        .saturation(useGrayscale ? 0 : 1)
        .overlay(
            useGrayscale
            ? Color.black.opacity(0.12)
            : Color.clear
        )
    }
}

private struct GeneratedPieceArtwork: View {
    let seedSource: String
    let useGrayscale: Bool

    private var seed: Int {
        seedSource.unicodeScalars.reduce(0) { acc, scalar in
            (acc * 31 + Int(scalar.value)) % 2048
        }
    }

    private var gradientColors: [Color] {
        let hueA = Double((seed * 13) % 100) / 100.0
        let hueB = Double((seed * 29 + 17) % 100) / 100.0
        return [
            Color(hue: hueA, saturation: 0.55, brightness: 0.88),
            Color(hue: hueB, saturation: 0.48, brightness: 0.75)
        ]
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)

            Circle()
                .fill(Color.white.opacity(0.24))
                .frame(width: CGFloat(70 + (seed % 30)))
                .offset(x: CGFloat((seed % 50) - 24), y: CGFloat(((seed / 3) % 40) - 20))

            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.black.opacity(0.10))
                .frame(width: CGFloat(80 + (seed % 40)), height: 26)
                .rotationEffect(.degrees(Double(seed % 90) - 45))

            Path { p in
                p.move(to: CGPoint(x: 12, y: 112))
                p.addCurve(
                    to: CGPoint(x: 220, y: 20),
                    control1: CGPoint(x: 80, y: CGFloat(90 - (seed % 40))),
                    control2: CGPoint(x: 150, y: CGFloat(30 + (seed % 50)))
                )
            }
            .stroke(Color.white.opacity(0.4), lineWidth: 2)
        }
        .saturation(useGrayscale ? 0 : 1)
        .overlay(
            useGrayscale
            ? Color.black.opacity(0.12)
            : Color.clear
        )
    }
}
