import SwiftUI

struct QuizView: View {
    let instruments: [Instrument]

    @State private var currentIndex = 0
    @State private var score = 0
    @State private var choices: [Instrument] = []
    @State private var answered = false
    @State private var feedback = ""

    private var current: Instrument { instruments[currentIndex] }

    var body: some View {
        VStack(spacing: 16) {
            Text("Question \(currentIndex + 1) / \(instruments.count)")
                .font(.headline)

            Text("Which instrument matches this description?")
                .font(.title3).bold()

            Text(current.cultureSummary)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))

            ForEach(choices, id: \.id) { option in
                Button {
                    answer(option)
                } label: {
                    HStack {
                        Text(option.nameEnglish)
                        Spacer()
                        Text(option.nameNative).foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background, in: RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.secondary.opacity(0.3), lineWidth: 1)
                    )
                }
                .disabled(answered)
            }

            if answered {
                Text(feedback).font(.headline)

                Button(currentIndex == instruments.count - 1 ? "Finish" : "Next") {
                    next()
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Quiz")
        .onAppear { makeChoices() }
    }

    private func makeChoices() {
        var pool = instruments.filter { $0.id != current.id }.shuffled()
        pool = Array(pool.prefix(3))
        pool.append(current)
        choices = pool.shuffled()
        answered = false
        feedback = ""
    }

    private func answer(_ option: Instrument) {
        answered = true
        if option.id == current.id {
            score += 1
            feedback = "✅ Correct! Score: \(score)"
        } else {
            feedback = "❌ Correct answer: \(current.nameEnglish)"
        }
    }

    private func next() {
        if currentIndex < instruments.count - 1 {
            currentIndex += 1
            makeChoices()
        } else {
            feedback = "Finished! Final score: \(score)/\(instruments.count)"
        }
    }
}
//
//  QuizView.swift
//  WorldInstrumentsExplorer
//
//  Created by zhengbei on 2026/2/9.
//

