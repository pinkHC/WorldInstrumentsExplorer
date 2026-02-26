import SwiftUI
import UniformTypeIdentifiers

struct DIYUploadView: View {
    let instrument: Instrument

    @State private var showUploadLink = false
    @State private var showImporter = false
    @State private var uploadedFileName: String?
    @State private var mailboxScale: CGFloat = 0.9
    @State private var mailboxLift: CGFloat = 16
    @State private var mailboxPulse = false

    var body: some View {
        ZStack {
            OldPaperBackground()
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("Upload your sheet music and listen to \(instrument.nameEnglish) playing it!")
                    .font(.custom("Times New Roman", size: 33))
                    .foregroundStyle(Color(red: 0.20, green: 0.14, blue: 0.09))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 680)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)

                Text("PDF / image / text accepted")
                    .font(.custom("Palatino-Italic", size: 22))
                    .foregroundStyle(Color(red: 0.33, green: 0.24, blue: 0.15).opacity(0.86))

                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        showUploadLink = true
                    }
                } label: {
                    MailboxHero(
                        showTapBadge: !showUploadLink,
                        pulsing: mailboxPulse
                    )
                }
                .buttonStyle(PressFeedbackStyle())
                .accessibilityLabel("Open mailbox")
                .scaleEffect(mailboxScale)
                .offset(y: mailboxLift)
                .onAppear {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.68)) {
                        mailboxScale = 1
                        mailboxLift = 0
                    }
                    mailboxPulse = true
                }

                if showUploadLink {
                    Button {
                        showImporter = true
                    } label: {
                        UploadParchmentCard()
                    }
                    .buttonStyle(PressFeedbackStyle())
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if let uploadedFileName {
                    SelectedStamp(text: "Sheet music selected: \(uploadedFileName)")
                        .transition(.scale.combined(with: .opacity))
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .animation(.easeInOut(duration: 0.25), value: showUploadLink)
        .animation(.easeInOut(duration: 0.22), value: uploadedFileName)
        .navigationTitle("DIY")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [
                .pdf,
                .image,
                .plainText
            ],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                uploadedFileName = urls.first?.lastPathComponent
            case .failure:
                uploadedFileName = nil
            }
        }
    }
}

private struct MailboxHero: View {
    let showTapBadge: Bool
    let pulsing: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 1.00, green: 0.95, blue: 0.74).opacity(0.55),
                            .clear
                        ],
                        center: .center,
                        startRadius: 4,
                        endRadius: 130
                    )
                )
                .frame(width: 280, height: 280)
                .scaleEffect(pulsing ? 1.02 : 0.98)
                .animation(
                    .easeInOut(duration: 1.6).repeatForever(autoreverses: true),
                    value: pulsing
                )

            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.86, green: 0.34, blue: 0.22),
                            Color(red: 0.74, green: 0.22, blue: 0.13)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 198, height: 198)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color(red: 0.48, green: 0.17, blue: 0.10), lineWidth: 1.2)
                )
                .shadow(color: Color(red: 0.25, green: 0.15, blue: 0.07).opacity(0.30), radius: 8, x: 0, y: 5)

            VStack(spacing: 8) {
                Capsule()
                    .fill(Color(red: 0.57, green: 0.16, blue: 0.10))
                    .frame(width: 100, height: 10)

                Image(systemName: "envelope.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.white.opacity(0.95))

                Text("Mailbox")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.95))
            }

            if showTapBadge {
                Text("Tap me")
                    .font(.custom("Copperplate-Bold", size: 14))
                    .foregroundStyle(Color(red: 0.36, green: 0.11, blue: 0.09))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(red: 0.96, green: 0.80, blue: 0.73))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color(red: 0.52, green: 0.17, blue: 0.15), lineWidth: 1)
                    )
                    .rotationEffect(.degrees(-8))
                    .offset(x: 86, y: -84)
            }
        }
        .frame(width: 290, height: 240)
    }
}

private struct UploadParchmentCard: View {
    @State private var floatShift: CGFloat = 0

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "music.note.list")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color(red: 0.24, green: 0.15, blue: 0.08))

            Text("Choose sheet music file")
                .font(.custom("Palatino-Bold", size: 25))
                .foregroundStyle(Color(red: 0.23, green: 0.15, blue: 0.08))
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.98, green: 0.92, blue: 0.75),
                            Color(red: 0.91, green: 0.82, blue: 0.58)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(red: 0.45, green: 0.34, blue: 0.18).opacity(0.50), lineWidth: 1.1)
        )
        .shadow(color: Color(red: 0.30, green: 0.22, blue: 0.12).opacity(0.22), radius: 5, x: 0, y: 3)
        .offset(y: floatShift)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.1).repeatForever(autoreverses: true)) {
                floatShift = -3
            }
        }
    }
}

private struct SelectedStamp: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.custom("Times New Roman", size: 18))
            .foregroundStyle(Color(red: 0.46, green: 0.15, blue: 0.12))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color(red: 0.56, green: 0.21, blue: 0.18), lineWidth: 1.2)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(red: 1.0, green: 0.94, blue: 0.88).opacity(0.56))
                    )
            )
            .rotationEffect(.degrees(-1.6))
    }
}

private struct OldPaperBackground: View {
    @State private var driftOffset: CGFloat = 0

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

            ForEach(0..<42, id: \.self) { i in
                Circle()
                    .fill(Color(red: 0.33, green: 0.24, blue: 0.12).opacity(i.isMultiple(of: 2) ? 0.020 : 0.012))
                    .frame(
                        width: CGFloat(24 + (i * 9 % 56)),
                        height: CGFloat(18 + (i * 7 % 44))
                    )
                    .position(
                        x: CGFloat(20 + (i * 37 % 360)),
                        y: CGFloat(30 + (i * 71 % 780))
                    )
            }
            .offset(x: driftOffset)

            Capsule()
                .fill(Color(red: 0.31, green: 0.23, blue: 0.11).opacity(0.08))
                .frame(width: 260, height: 18)
                .rotationEffect(.degrees(-11))
                .offset(x: -105, y: -230)

            Capsule()
                .fill(Color(red: 0.31, green: 0.23, blue: 0.11).opacity(0.07))
                .frame(width: 228, height: 16)
                .rotationEffect(.degrees(14))
                .offset(x: 120, y: 250)

            LinearGradient(
                colors: [
                    Color.black.opacity(0.15),
                    Color.clear,
                    Color.black.opacity(0.17)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .blendMode(.multiply)
        }
        .onAppear {
            withAnimation(.linear(duration: 18).repeatForever(autoreverses: true)) {
                driftOffset = 6
            }
        }
    }
}

private struct PressFeedbackStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .brightness(configuration.isPressed ? -0.03 : 0.0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}
