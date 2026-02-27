import SwiftUI
#if os(iOS)
import UIKit
#endif

struct QuizView: View {
    let instruments: [Instrument]

    @State private var currentIndex = 0
    @State private var score = 0
    @State private var choices: [Instrument] = []
    @State private var selectedOption: Instrument? = nil
    @State private var isAnswerCorrect: Bool? = nil
    @State private var isFinished = false
    @State private var showFeedbackAlert = false
    @State private var feedbackTitle = ""
    @State private var shouldScrollToTopAfterNext = false

    private var current: Instrument { instruments[currentIndex] }
    @Environment(\.dismiss) private var dismiss
    #if os(iOS)
    private var isPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    #else
    private let isPhone = false
    #endif

    var body: some View {
        GeometryReader { _ in
            ZStack {
                backgroundView

                if isPhone {
                    ScrollViewReader { scrollProxy in
                        ScrollView(showsIndicators: true) {
                            Color.clear
                                .frame(height: 0)
                                .id("quizTopAnchor")

                            cardStack
                                .padding(.vertical, 0)
                                .frame(maxWidth: .infinity)
                        }
                        .onChange(of: shouldScrollToTopAfterNext) { _, shouldScroll in
                            guard shouldScroll else { return }
                            withAnimation(.easeOut(duration: 0.2)) {
                                scrollProxy.scrollTo("quizTopAnchor", anchor: .top)
                            }
                            shouldScrollToTopAfterNext = false
                        }
                        .contentMargins(.vertical, 0, for: .scrollContent)
                        .contentMargins(.vertical, 0, for: .scrollIndicators)
                    }
                } else {
                    VStack {
                        Spacer(minLength: 0)
                        cardStack
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 28)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Quiz")
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
        .onAppear { makeChoices() }
        .animation(.easeOut(duration: 0.28), value: selectedOption)
        .animation(.easeOut(duration: 0.28), value: currentIndex)
        .alert(feedbackTitle, isPresented: $showFeedbackAlert) {
            Button("OK") { }
        } message: {
            if isAnswerCorrect == true {
                Text("Great job! Move to the next question.")
            } else {
                Text("The correct answer is: \(current.nameEnglish)")
            }
        }
        .alert("Quiz Finished", isPresented: $isFinished) {
            Button("Restart", role: .cancel) {
                currentIndex = 0
                score = 0
                makeChoices()
            }
            Button("Main Menu") { dismiss() }
        } message: {
            Text("Your final score is \(score) out of \(instruments.count).")
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            Image("world_map")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .opacity(0.95)
                .accessibilityHidden(true)

            Color.black.opacity(0.08)
                .ignoresSafeArea()
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
        .padding(.leading, -6)
        .padding(.top, 8)
    }

    @ViewBuilder
    private var cardStack: some View {
        cardContent
            .padding(.horizontal, 26)
            .padding(.vertical, isPhone ? 12 : 26)
            .frame(maxWidth: 900)
            .background {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.97, green: 0.94, blue: 0.86),
                                Color(red: 0.91, green: 0.85, blue: 0.72)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color(red: 0.36, green: 0.25, blue: 0.15).opacity(0.35), lineWidth: 1.4)
                    )
                    .shadow(color: .black.opacity(0.22), radius: 14, x: 0, y: 8)
            }
            .background {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(red: 0.95, green: 0.91, blue: 0.8).opacity(0.75))
                    .rotationEffect(.degrees(-1.3))
                    .offset(x: -5, y: 8)
            }
            .padding(.horizontal, isPhone ? 16 : 28)
    }

    @ViewBuilder
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerBar
            progressBar
            questionSection
            optionsList
            Spacer(minLength: 24)
            bottomButtons
        }
    }

    @ViewBuilder
    private var headerBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "map.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color(red: 0.22, green: 0.22, blue: 0.2))

            Text("Instrument Trial")
                .font(.custom("Copperplate-Bold", size: 26))
                .foregroundStyle(Color.black.opacity(0.82))

            Spacer()

            Text("Q\(currentIndex + 1)/\(instruments.count)")
                .font(.custom("Times New Roman", size: 21))
                .foregroundStyle(Color.black.opacity(0.72))
        }
    }

    @ViewBuilder
    private var progressBar: some View {
        HStack(spacing: 8) {
            ForEach(0..<instruments.count, id: \.self) { index in
                ProgressDash(isActive: index <= currentIndex)
            }
        }
        .padding(.top, 18)
    }

    @ViewBuilder
    private var questionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Which instrument matches this description?")
                .font(.custom("Copperplate-Bold", size: 25))
                .foregroundStyle(Color.black.opacity(0.85))
                .padding(.top, 20)

            Text(current.cultureSummary)
                .font(.custom("Times New Roman", size: 23))
                .foregroundStyle(Color.black.opacity(0.74))
                .fixedSize(horizontal: false, vertical: true)

            Text("Select only one")
                .font(.custom("Marker Felt", size: 21))
                .foregroundStyle(Color(red: 0.34, green: 0.24, blue: 0.16).opacity(0.86))
                .padding(.top, 8)
        }
    }

    @ViewBuilder
    private var optionsList: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(choices, id: \.id) { option in
                ChoiceRow(
                    option: option,
                    isSelected: selectedOption?.id == option.id,
                    isCorrect: isAnswerCorrect,
                    showCorrectAnswer: selectedOption != nil && option.id == current.id
                )
                .onTapGesture {
                    if selectedOption == nil {
                        answer(option)
                    }
                }
            }
        }
        .padding(.top, 20)
    }

    @ViewBuilder
    private var bottomButtons: some View {
        HStack {
            Button {
                if currentIndex > 0 {
                    currentIndex -= 1
                    selectedOption = nil
                    isAnswerCorrect = nil
                    makeChoices()
                } else {
                    dismiss()
                }
            } label: {
                Text("Back")
                    .font(.custom("Marker Felt", size: 26))
                    .foregroundStyle(Color.black.opacity(0.8))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .fill(Color(red: 0.88, green: 0.8, blue: 0.63).opacity(0.72))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .stroke(Color.black.opacity(0.25), lineWidth: 1.0)
                    )
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                if selectedOption != nil { next() }
            } label: {
                nextButtonLabel
            }
            .buttonStyle(.plain)
            .disabled(selectedOption == nil)
        }
        .padding(.bottom, 4)
    }

    @ViewBuilder
    private var nextButtonLabel: some View {
        let title = currentIndex == instruments.count - 1 ? "Finish" : "Next"

        HStack(spacing: 8) {
            Image(systemName: "arrow.right")
                .font(.system(size: 21, weight: .bold))
            Text(title)
                .font(.custom("Copperplate-Bold", size: 24))
        }
        .foregroundStyle(Color.black.opacity(0.88))
        .padding(.horizontal, 26)
        .padding(.vertical, 14)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.76, green: 0.57, blue: 0.35),
                    Color(red: 0.67, green: 0.49, blue: 0.28)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(red: 0.34, green: 0.22, blue: 0.12), lineWidth: 1.2)
        )
        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
        .opacity(selectedOption == nil ? 0.35 : 1.0)
    }

    private func makeChoices() {
        var pool = instruments.filter { $0.id != current.id }.shuffled()
        pool = Array(pool.prefix(3))
        pool.append(current)
        choices = pool.shuffled()
        selectedOption = nil
        isAnswerCorrect = nil
    }

    private func answer(_ option: Instrument) {
        selectedOption = option
        if option.id == current.id {
            score += 1
            isAnswerCorrect = true
            feedbackTitle = "✅ Correct!"
        } else {
            isAnswerCorrect = false
            feedbackTitle = "❌ Wrong!"
        }
        showFeedbackAlert = true
    }

    private func next() {
        if currentIndex < instruments.count - 1 {
            currentIndex += 1
            makeChoices()
            if isPhone {
                shouldScrollToTopAfterNext = true
            }
        } else {
            isFinished = true
        }
    }
}

struct ChoiceRow: View {
    let option: Instrument
    let isSelected: Bool
    let isCorrect: Bool?
    let showCorrectAnswer: Bool

    private var isSuccess: Bool { (isSelected && isCorrect == true) || showCorrectAnswer }
    private var isFailure: Bool { isSelected && isCorrect == false }

    private var tagFill: LinearGradient {
        if isSuccess {
            return LinearGradient(
                colors: [
                    Color(red: 0.74, green: 0.85, blue: 0.64),
                    Color(red: 0.63, green: 0.76, blue: 0.53)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        if isFailure {
            return LinearGradient(
                colors: [
                    Color(red: 0.9, green: 0.74, blue: 0.64),
                    Color(red: 0.82, green: 0.62, blue: 0.53)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        return LinearGradient(
            colors: [
                Color(red: 0.94, green: 0.89, blue: 0.74),
                Color(red: 0.88, green: 0.8, blue: 0.63)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var indicatorSymbol: String {
        if isFailure { return "xmark" }
        if isSuccess { return "checkmark" }
        return "circle.fill"
    }

    private var statusText: String? {
        if isFailure { return "Wrong" }
        if isSuccess { return "Correct" }
        return nil
    }

    private var indicatorColor: Color {
        if isSuccess { return Color(red: 0.25, green: 0.44, blue: 0.2) }
        if isFailure { return Color(red: 0.52, green: 0.2, blue: 0.14) }
        return Color.black.opacity(0.55)
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: indicatorSymbol)
                .font(.system(size: 22, weight: .black))
                .foregroundStyle(indicatorColor)
                .frame(width: 42, height: 42)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.92))
                )
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.35), lineWidth: 1.6)
                )

            Text(option.nameEnglish)
                .font(.custom("Marker Felt", size: 30))
                .foregroundStyle(Color.black.opacity(0.86))
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            Spacer()

            if let statusText {
                Text(statusText)
                    .font(.custom("Copperplate-Bold", size: 18))
                    .foregroundStyle(Color.black.opacity(0.9))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.white.opacity(0.8))
                    )
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.black.opacity(0.32), lineWidth: 1.0)
                    )
            }
        }
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity)
        .frame(height: 72)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(tagFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(red: 0.34, green: 0.22, blue: 0.12).opacity(0.45), lineWidth: 1.1)
        )
        .shadow(color: .black.opacity(0.14), radius: 2, x: 0, y: 2)
        .contentShape(Rectangle())
    }
}

private struct ProgressDash: View {
    let isActive: Bool

    var body: some View {
        if isActive {
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.58, green: 0.37, blue: 0.2),
                            Color(red: 0.82, green: 0.66, blue: 0.34)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 5)
        } else {
            Capsule()
                .fill(Color.black.opacity(0.13))
                .frame(height: 5)
        }
    }
}
