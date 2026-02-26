import Foundation

enum SampleData {
    static let instruments: [Instrument] = [
        Instrument(
            id: "guqin",
            nameEnglish: "Guqin",
            nameNative: "古琴",
            region: "China",
            latitude: 34.6197,
            longitude: 112.4540,
            cultureSummary: "A seven-string zither associated with scholars, meditation, and literati culture.",
            funFact: "The guqin has over 3,000 years of history.",
            classicPieces: [
                ClassicPiece(
                    id: "guqin-guanglingsan",
                    title: "Guangling San",
                    performer: "Traditional",
                    audioFile: "guqin_guanglingsan.mp3",
                    durationSec: 320
                ),
                ClassicPiece(
                    id: "guqin-flowingwater",
                    title: "Flowing Water",
                    performer: "Traditional",
                    audioFile: "guqin_flowingwater.mp3",
                    durationSec: 280
                ),
                ClassicPiece(
                    id: "guqin-yangguansandie",
                    title: "Yangguan Sandie",
                    performer: "Traditional",
                    audioFile: "guqin_yangguansandie.mp3",
                    durationSec: 300
                ),
                ClassicPiece(
                    id: "guqin-meihuasannong",
                    title: "Meihua Sannong",
                    performer: "Traditional",
                    audioFile: "guqin_meihuasannong.mp3",
                    durationSec: 310
                ),
                ClassicPiece(
                    id: "guqin-pingshaluoyan",
                    title: "Pingsha Luoyan",
                    performer: "Traditional",
                    audioFile: "guqin_pingshaluoyan.mp3",
                    durationSec: 290
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
                    audioFile: "pipa_ambush.mp3",
                    durationSec: 360
                ),
                ClassicPiece(
                    id: "pipa-danceyi",
                    title: "Dance of the Yi People",
                    performer: "Traditional",
                    audioFile: "pipa_danceyi.mp3",
                    durationSec: 330
                ),
                ClassicPiece(
                    id: "pipa-springmoonriver",
                    title: "Spring Flowers on Moonlit River",
                    performer: "Traditional",
                    audioFile: "pipa_springmoonriver.mp3",
                    durationSec: 340
                ),
                ClassicPiece(
                    id: "pipa-kingarmor",
                    title: "The King Doffs His Armor",
                    performer: "Traditional",
                    audioFile: "pipa_kingarmor.mp3",
                    durationSec: 350
                ),
                ClassicPiece(
                    id: "pipa-silkroaddance",
                    title: "Dance along the Old Silk Road",
                    performer: "Traditional",
                    audioFile: "pipa_silkroaddance.mp3",
                    durationSec: 320
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
            latitude: 34.6851,
            longitude: 135.8048,
            cultureSummary: "A long zither with movable bridges, central to traditional Japanese music.",
            funFact: "A modern standard koto typically has 13 strings.",
            classicPieces: [
                ClassicPiece(
                    id: "koto-rokudan",
                    title: "Rokudan no Shirabe",
                    performer: "Traditional",
                    audioFile: "koto_rokudan.mp3",
                    durationSec: 300
                ),
                ClassicPiece(
                    id: "koto-midare",
                    title: "Midare",
                    performer: "Traditional",
                    audioFile: "koto_midare.mp3",
                    durationSec: 295
                ),
                ClassicPiece(
                    id: "koto-hachidan",
                    title: "Hachidan no Shirabe",
                    performer: "Traditional",
                    audioFile: "koto_hachidan.mp3",
                    durationSec: 305
                ),
                ClassicPiece(
                    id: "koto-chidori",
                    title: "Chidori no Kyoku",
                    performer: "Traditional",
                    audioFile: "koto_chidori.mp3",
                    durationSec: 285
                ),
                ClassicPiece(
                    id: "koto-harunoumi",
                    title: "Haru no Umi",
                    performer: "Traditional",
                    audioFile: "koto_harunoumi.mp3",
                    durationSec: 315
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
            latitude: 33.3152,
            longitude: 44.3661,
            cultureSummary: "A fretless lute with warm timbre used across Middle Eastern traditions.",
            funFact: "The oud is often considered an ancestor of the European lute.",
            classicPieces: [
                ClassicPiece(
                    id: "oud-longariyad",
                    title: "Longa Riyad",
                    performer: "Traditional",
                    audioFile: "oud_longariyad.mp3",
                    durationSec: 240
                ),
                ClassicPiece(
                    id: "oud-samaibayati",
                    title: "Sama'i Bayati",
                    performer: "Traditional",
                    audioFile: "oud_samaibayati.mp3",
                    durationSec: 260
                ),
                ClassicPiece(
                    id: "oud-samainahawand",
                    title: "Sama'i Nahawand",
                    performer: "Traditional",
                    audioFile: "oud_samainahawand.mp3",
                    durationSec: 255
                ),
                ClassicPiece(
                    id: "oud-taqsimbayati",
                    title: "Taqsim Bayati",
                    performer: "Traditional",
                    audioFile: "oud_taqsimbayati.mp3",
                    durationSec: 230
                ),
                ClassicPiece(
                    id: "oud-lammabada",
                    title: "Lamma Bada Yatathanna",
                    performer: "Traditional",
                    audioFile: "oud_lammabada.mp3",
                    durationSec: 275
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
            latitude: 13.4549,
            longitude: -16.5790,
            cultureSummary: "A 21-string harp-lute played by griots for oral history and praise songs.",
            funFact: "The kora blends harp-like resonance with lute-style plucking.",
            classicPieces: [
                ClassicPiece(
                    id: "kora-kaira",
                    title: "Kaira",
                    performer: "Traditional",
                    audioFile: "kora_kaira.mp3",
                    durationSec: 260
                ),
                ClassicPiece(
                    id: "kora-jarabi",
                    title: "Jarabi",
                    performer: "Traditional",
                    audioFile: "kora_jarabi.mp3",
                    durationSec: 250
                ),
                ClassicPiece(
                    id: "kora-allalaake",
                    title: "Alla L'aa Ke",
                    performer: "Traditional",
                    audioFile: "kora_allalaake.mp3",
                    durationSec: 245
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
