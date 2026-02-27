import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

struct PartsAndPerformanceView: View {
    let instrument: Instrument
    @Environment(\.dismiss) private var dismiss
    #if os(iOS)
    private var isPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    #else
    private let isPhone = false
    #endif

    private var partsImageNames: [String] {
        switch instrument.id {
        case "guqin":
            return ["guqin-pp-config", "guqin-pp-config-2"]
        case "pipa":
            return ["pipa-pp-config"]
        case "koto":
            return ["koto-pp-config"]
        case "oud":
            return ["oud-pp-config", "oud-pp-config-2"]
        case "kora":
            return ["kora-pp-config", "kora-pp-config-2"]
        default:
            return []
        }
    }

    private var performanceImageNames: [String] {
        switch instrument.id {
        case "guqin":
            return ["guqin-pp-play-1", "guqin-pp-play-2", "guqin-pp-play-3"]
        case "pipa":
            return ["pipa-pp-play-1", "pipa-pp-play-2"]
        case "koto":
            return ["koto-pp-play-1", "koto-pp-play-2"]
        case "oud":
            return ["oud-pp-play-1", "oud-pp-play-2"]
        case "kora":
            return ["kora-pp-play"]
        default:
            return []
        }
    }

    var body: some View {
        GeometryReader { proxy in
            let cardImageHeight = adaptiveCardImageHeight(
                viewportWidth: proxy.size.width,
                viewportHeight: proxy.size.height
            )

            ScrollView {
                VStack(spacing: 18) {
                    Text("\(instrument.nameEnglish): Parts & Performance")
                        .font(.custom("Copperplate-Bold", size: 32))
                        .foregroundStyle(Color.black.opacity(0.84))
                        .multilineTextAlignment(.center)
                        .padding(.top, isPhone ? 0 : 18)
                        .padding(.horizontal, 16)

                    imageCardLink(
                        title: "Parts",
                        subtitle: "",
                        symbol: "square.split.2x1",
                        imageNames: partsImageNames,
                        destinationTitle: "Parts Photos",
                        pageHeading: "Parts",
                        cardImageHeight: cardImageHeight
                    )

                    imageCardLink(
                        title: "Performance",
                        subtitle: "",
                        symbol: "person.fill",
                        imageNames: performanceImageNames,
                        destinationTitle: "Performance Photos",
                        pageHeading: "Performance",
                        cardImageHeight: cardImageHeight
                    )

                    Text("Thank you for using INSTRUMENT ATLAS!")
                        .font(.custom("Palatino-Italic", size: 18))
                        .foregroundStyle(Color.black.opacity(0.72))
                        .multilineTextAlignment(.center)
                        .padding(.top, isPhone ? 0 : 6)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, isPhone ? 0 : 24)
            }
            #if os(iOS)
            .contentMargins(.vertical, isPhone ? 0 : nil, for: .scrollContent)
            .contentMargins(.vertical, isPhone ? 0 : nil, for: .scrollIndicators)
            #endif
        }
        .safeAreaPadding(.top, isPhone ? 0 : 8)
        .safeAreaPadding(.bottom, isPhone ? 0 : 8)
        .background(OldPaperBackground().ignoresSafeArea().accessibilityHidden(true))
        .navigationTitle("Parts & Performance")
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
        #elseif os(macOS)
        .toolbarBackground(.white, for: .windowToolbar)
        .toolbarBackground(.visible, for: .windowToolbar)
        .toolbarColorScheme(.light, for: .windowToolbar)
        #endif
    }

    @ViewBuilder
    private func imageCardLink(
        title: String,
        subtitle: String,
        symbol: String,
        imageNames: [String],
        destinationTitle: String,
        pageHeading: String,
        cardImageHeight: CGFloat
    ) -> some View {
        Group {
            if let coverImageName = imageNames.first {
                NavigationLink {
                    ImageCategoryGalleryView(title: destinationTitle, pageHeading: pageHeading, imageNames: imageNames)
                } label: {
                    ImageHolderCard(
                        title: title,
                        subtitle: subtitle,
                        symbol: symbol,
                        imageName: coverImageName,
                        isInteractive: true,
                        imageAreaHeight: cardImageHeight
                    )
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .accessibilityLabel("\(title) photos")
                .accessibilityHint("Open the \(title.lowercased()) gallery.")
            } else {
                ImageHolderCard(
                    title: title,
                    subtitle: "No photos added yet.",
                    symbol: symbol,
                    imageName: nil,
                    isInteractive: false,
                    imageAreaHeight: cardImageHeight
                )
            }
        }
        .frame(maxWidth: 760)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func adaptiveCardImageHeight(viewportWidth: CGFloat, viewportHeight: CGFloat) -> CGFloat {
        let base = max(viewportHeight * 0.28, viewportWidth * 0.22)
        return min(max(base, 220), 420)
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

private struct ImageHolderCard: View {
    let title: String
    let subtitle: String
    let symbol: String
    let imageName: String?
    let isInteractive: Bool
    let imageAreaHeight: CGFloat

    private var hasImage: Bool {
        guard let imageName else { return false }
        #if os(iOS)
        return UIImage(named: imageName) != nil
        #elseif os(macOS)
        return NSImage(named: NSImage.Name(imageName)) != nil
        #else
        return false
        #endif
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if hasImage, let imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .overlay(Color.black.opacity(0.05))
                } else {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.48, green: 0.28, blue: 0.15).opacity(0.78),
                                    Color(red: 0.40, green: 0.22, blue: 0.12).opacity(0.50)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    VStack(spacing: 8) {
                        Image(systemName: symbol)
                            .font(.system(size: 38, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.95))
                            .accessibilityHidden(true)

                        Text("Image Holder")
                            .font(.custom("Palatino-Bold", size: 18))
                            .foregroundStyle(.white.opacity(0.92))
                    }
                }

                VStack {
                    Spacer()
                }
            }
            .frame(height: imageAreaHeight)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            if isInteractive, hasImage {
                Text("Tap to open")
                    .font(.custom("Palatino-Italic", size: 14))
                    .foregroundStyle(Color.black.opacity(0.6))
            }

            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.custom("Palatino", size: 17))
                    .foregroundStyle(Color.black.opacity(0.68))
                    .lineLimit(2)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.92))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.black.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.10), radius: 4, x: 0, y: 2)
        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabelText)
        .accessibilityValue(isInteractive ? "Available" : "Unavailable")
        .accessibilityHint(isInteractive ? "Double tap to open photos." : "No photos added yet.")
    }

    private var accessibilityLabelText: String {
        if let imageName, hasImage {
            return "\(title), preview image \(friendlyImageName(imageName))"
        }
        return "\(title), image holder"
    }

    private func friendlyImageName(_ rawName: String) -> String {
        rawName
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "_", with: " ")
    }
}

private struct ImageCategoryGalleryView: View {
    let title: String
    let pageHeading: String
    let imageNames: [String]
    @Environment(\.dismiss) private var dismiss
    #if os(iOS)
    private var isPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    #else
    private let isPhone = false
    #endif

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                Text(pageHeading)
                    .font(.custom("Snell Roundhand Black", size: 44))
                    .foregroundStyle(Color.black.opacity(0.82))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 4)

                ForEach(imageNames, id: \.self) { imageName in
                    GalleryImageCard(imageName: imageName)
                }

                Text("Thank you for using INSTRUMENT ATLAS!")
                    .font(.custom("Palatino-Italic", size: 18))
                    .foregroundStyle(Color.black.opacity(0.72))
                    .multilineTextAlignment(.center)
                    .padding(.top, isPhone ? 0 : 6)
            }
            .padding(.horizontal, 12)
            .padding(.top, isPhone ? 0 : 12)
            .padding(.bottom, isPhone ? 0 : 12)
        }
        #if os(iOS)
        .contentMargins(.vertical, isPhone ? 0 : nil, for: .scrollContent)
        .contentMargins(.vertical, isPhone ? 0 : nil, for: .scrollIndicators)
        #endif
        .safeAreaPadding(.top, isPhone ? 0 : 8)
        .safeAreaPadding(.bottom, isPhone ? 0 : 8)
        .background(OldPaperBackground().ignoresSafeArea())
        .navigationTitle(title)
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
        #elseif os(macOS)
        .toolbarBackground(.white, for: .windowToolbar)
        .toolbarBackground(.visible, for: .windowToolbar)
        .toolbarColorScheme(.light, for: .windowToolbar)
        #endif
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

private struct GalleryImageCard: View {
    let imageName: String
    private let maxDisplayWidth: CGFloat = 720
    private let maxDisplayHeight: CGFloat = 520

    private var naturalSize: CGSize? {
        #if os(iOS)
        return UIImage(named: imageName)?.size
        #elseif os(macOS)
        return NSImage(named: NSImage.Name(imageName))?.size
        #else
        return nil
        #endif
    }

    private var targetWidth: CGFloat {
        guard let naturalSize else { return 520 }
        return min(naturalSize.width, maxDisplayWidth)
    }

    private var targetHeight: CGFloat {
        guard let naturalSize else { return 380 }
        return min(naturalSize.height, maxDisplayHeight)
    }

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: targetWidth, maxHeight: targetHeight)
                .padding(10)
                .background(Color.black.opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.black.opacity(0.24), lineWidth: 1)
                )
                .accessibilityLabel(friendlyImageName(imageName))
        }
        .frame(maxWidth: .infinity)
    }

    private func friendlyImageName(_ rawName: String) -> String {
        rawName
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "_", with: " ")
    }
}

private struct OldPaperBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.93, blue: 0.73),
                    Color(red: 0.91, green: 0.82, blue: 0.56)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            ForEach(0..<40, id: \.self) { i in
                Circle()
                    .fill(Color(red: 0.33, green: 0.24, blue: 0.12).opacity(i.isMultiple(of: 2) ? 0.020 : 0.012))
                    .frame(
                        width: CGFloat(22 + (i * 9 % 54)),
                        height: CGFloat(18 + (i * 7 % 44))
                    )
                    .position(
                        x: CGFloat(20 + (i * 37 % 360)),
                        y: CGFloat(30 + (i * 71 % 780))
                    )
            }

            LinearGradient(
                colors: [
                    Color.black.opacity(0.14),
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
