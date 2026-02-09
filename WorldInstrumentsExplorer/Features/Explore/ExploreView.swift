import SwiftUI
import MapKit

struct ExploreView: View {
    @State private var selected: Instrument? = SampleData.instruments.first
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25, longitude: 100),
            span: MKCoordinateSpan(latitudeDelta: 120, longitudeDelta: 220)
        )
    )

    private let instruments = SampleData.instruments

    var body: some View {
        NavigationSplitView {
            List(instruments, selection: $selected) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.nameEnglish)
                        .font(.headline)
                    Text("\(item.nameNative) · \(item.region)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
                .contentShape(Rectangle())
                .onTapGesture {
                    selected = item
                    focusMap(on: item)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(item.nameEnglish), \(item.region)")
                .accessibilityHint("Open instrument details")
            }
            .navigationTitle("Instruments")
        } detail: {
            VStack(spacing: 12) {
                Map(position: $cameraPosition) {
                    ForEach(instruments) { item in
                        Annotation(item.nameEnglish, coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)) {
                            Button {
                                selected = item
                                focusMap(on: item)
                            } label: {
                                Image(systemName: "music.note")
                                    .padding(8)
                                    .background(.thinMaterial, in: Circle())
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(item.nameEnglish), \(item.region)")
                            .accessibilityHint("Show details")
                        }
                    }
                }
                .frame(minHeight: 300)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                if let selected {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(selected.nameEnglish) (\(selected.nameNative))")
                            .font(.title3).bold()
                        Text(selected.cultureSummary)
                        Text("Fun fact: \(selected.funFact)")
                            .foregroundStyle(.secondary)

                        NavigationLink("Open Detail") {
                            InstrumentDetailView(instrument: selected)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                } else {
                    Text("Select an instrument from the list or map.")
                        .foregroundStyle(.secondary)
                }

                NavigationLink("Start Quiz") {
                    QuizView(instruments: instruments)
                }
                .buttonStyle(.bordered)
                .padding(.bottom, 16)

                Spacer()
            }
            .navigationTitle("World Explorer")
        }
    }

    private func focusMap(on item: Instrument) {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude),
                span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
            )
        )
    }
}
//
//  ExploreView.swift
//  WorldInstrumentsExplorer
//
//  Created by zhengbei on 2026/2/9.
//

