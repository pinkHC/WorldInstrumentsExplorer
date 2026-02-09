import Foundation

enum SampleData {
    static let instruments: [Instrument] = [
        Instrument(
            id: "guqin",
            nameEnglish: "Guqin",
            nameNative: "古琴",
            region: "China",
            latitude: 30.2741,
            longitude: 120.1551,
            cultureSummary: "A seven-string zither associated with scholars, meditation, and literati culture.",
            funFact: "The guqin has over 3,000 years of history.",
            classicPieces: [
                ClassicPiece(
                    id: "guqin-guanglingsan",
                    title: "Guangling San",
                    performer: "Traditional",
                    audioFile: "guqin_guanglingsan.m4a",
                    durationSec: 320
                ),
                ClassicPiece(
                    id: "guqin-flowingwater",
                    title: "Flowing Water",
                    performer: "Traditional",
                    audioFile: "guqin_flowingwater.m4a",
                    durationSec: 280
                )
            ],
            synthesisProfile: SynthesisProfile(
                engineType: .sampler,
                presetName: "GuqinPreset",
                modelFile: nil
            )
        ),
        Instrument(
            id: "pipa",
            nameEnglish: "Pipa",
            nameNative: "琵琶",
            region: "China",
            latitude: 34.3416,
            longitude: 108.9398,
            cultureSummary: "A pear-shaped lute known for rapid finger techniques and expressive storytelling.",
            funFact: "Its techniques can imitate horses, wind, and battlefield scenes.",
            classicPieces: [
                ClassicPiece(
                    id: "pipa-ambush",
                    title: "Ambush from Ten Sides",
                    performer: "Traditional",
                    audioFile: "pipa_ambush.m4a",
                    durationSec: 360
                )
            ],
            synthesisProfile: SynthesisProfile(
                engineType: .sampler,
                presetName: "PipaPreset",
                modelFile: nil
            )
        ),
        Instrument(
            id: "koto",
            nameEnglish: "Koto",
            nameNative: "琴",
            region: "Japan",
            latitude: 35.6762,
            longitude: 139.6503,
            cultureSummary: "A long zither with movable bridges, central to traditional Japanese music.",
            funFact: "A modern standard koto typically has 13 strings.",
            classicPieces: [
                ClassicPiece(
                    id: "koto-rokudan",
                    title: "Rokudan no Shirabe",
                    performer: "Traditional",
                    audioFile: "koto_rokudan.m4a",
                    durationSec: 300
                )
            ],
            synthesisProfile: SynthesisProfile(
                engineType: .sampler,
                presetName: "KotoPreset",
                modelFile: nil
            )
        ),
        Instrument(
            id: "oud",
            nameEnglish: "Oud",
            nameNative: "العود",
            region: "Middle East",
            latitude: 33.8938,
            longitude: 35.5018,
            cultureSummary: "A fretless lute with warm timbre used across Middle Eastern traditions.",
            funFact: "The oud is often considered an ancestor of the European lute.",
            classicPieces: [
                ClassicPiece(
                    id: "oud-taqsim",
                    title: "Taqsim",
                    performer: "Traditional",
                    audioFile: "oud_taqsim.m4a",
                    durationSec: 240
                )
            ],
            synthesisProfile: SynthesisProfile(
                engineType: .sampler,
                presetName: "OudPreset",
                modelFile: nil
            )
        ),
        Instrument(
            id: "kora",
            nameEnglish: "Kora",
            nameNative: "Kora",
            region: "West Africa",
            latitude: 14.7167,
            longitude: -17.4677,
            cultureSummary: "A 21-string harp-lute played by griots for oral history and praise songs.",
            funFact: "The kora blends harp-like resonance with lute-style plucking.",
            classicPieces: [
                ClassicPiece(
                    id: "kora-birimg",
                    title: "Birimintingo",
                    performer: "Traditional",
                    audioFile: "kora_birimg.m4a",
                    durationSec: 260
                )
            ],
            synthesisProfile: SynthesisProfile(
                engineType: .sampler,
                presetName: "KoraPreset",
                modelFile: nil
            )
        )
    ]
}
