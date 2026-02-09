import SwiftUI

struct InstrumentDetailView: View {
    let instrument: Instrument

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                // Title
                Text("\(instrument.nameEnglish) (\(instrument.nameNative))")
                    .font(.title2)
                    .bold()

                Text("Region: \(instrument.region)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                // Culture
                Group {
                    Text("About")
                        .font(.headline)
                    Text(instrument.cultureSummary)
                        .font(.body)
                    Text("Fun fact: \(instrument.funFact)")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                Divider()

                // Synthesis info
                Group {
                    Text("Sound Generation")
                        .font(.headline)

                    Text("Engine: \(instrument.synthesisProfile.engineType.rawValue.capitalized)")
                        .font(.subheadline)

                    if let preset = instrument.synthesisProfile.presetName {
                        Text("Preset: \(preset)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    if let model = instrument.synthesisProfile.modelFile {
                        Text("Model: \(model)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Model: Not configured yet")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Button("Generate from Demo Notes (Coming Soon)") {
                        // Placeholder for next step: call your sound engine here
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityLabel("Generate from demo notes")
                    .accessibilityHint("Will generate instrument sound from note input")
                }

                Divider()

                // Classic pieces
                Group {
                    Text("Classic Pieces")
                        .font(.headline)

                    if instrument.classicPieces.isEmpty {
                        Text("No pieces added yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(instrument.classicPieces) { piece in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(piece.title)
                                    .font(.body)
                                    .bold()

                                if let performer = piece.performer {
                                    Text("Performer: \(performer)")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }

                                if let duration = piece.durationSec {
                                    Text("Duration: \(duration) sec")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }

                                Text("Audio file: \(piece.audioFile)")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)

                                Button("Play (Coming Soon)") {
                                    // Placeholder for next step: play local audio file
                                }
                                .buttonStyle(.bordered)
                                .accessibilityLabel("Play \(piece.title)")
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(instrument.nameEnglish)
    }
}
//
//  InstrumentDetailView.swift
//  WorldInstrumentsExplorer
//
//  Created by zhengbei on 2026/2/9.
//

