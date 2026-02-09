import Foundation
import CoreLocation

struct Instrument: Identifiable, Codable, Hashable {
    let id: String
    let nameEnglish: String
    let nameNative: String
    let region: String
    let latitude: Double
    let longitude: Double
    let cultureSummary: String
    let funFact: String
    
    let classicPieces: [ClassicPiece]
    let synthesisProfile: SynthesisProfile // to be improved with ML models or physical modeling synth models
}

struct ClassicPiece: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let performer: String?
    let audioFile: String      // local resource filename
    let durationSec: Int?
}

struct SynthesisProfile: Codable, Hashable {
    let engineType: EngineType
    let presetName: String?    // e.g. sampler preset
    let modelFile: String?     // e.g. CoreML model name (future)
}

enum EngineType: String, Codable, Hashable {
    case sampler      // immediate choice
    case physical     // future
    case neural       // future CoreML
}
//
//  Instrument.swift
//  WorldInstrumentsExplorer
//
//  Created by zhengbei on 2026/2/9.
//

