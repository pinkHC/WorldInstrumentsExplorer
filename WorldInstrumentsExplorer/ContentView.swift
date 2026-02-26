//
//  ContentView.swift
//  WorldInstrumentsExplorer
//
//  Created by zhengbei on 2026/2/7.
//

import SwiftUI

struct ContentView: View {
    private let instruments = SampleData.instruments

    @State private var showLandingTitle = false
    @State private var showLandingActions = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                Image("world_map")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .scaleEffect(showLandingTitle ? 1 : 1.03)
                    .opacity(showLandingTitle ? 1 : 0.94)

                Color.black.opacity(0.08)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    Text("Instrument Atlas")
                        .font(.custom("Times New Roman", size: 72))
                        .italic()
                        .foregroundStyle(.black)
                        .shadow(color: .black.opacity(0.8), radius: 6, x: 0, y: 2)
                        .padding(.bottom, 8)
                        .scaleEffect(showLandingTitle ? 1 : 0.95)
                        .opacity(showLandingTitle ? 1 : 0)
                        .offset(y: showLandingTitle ? 0 : 18)
                        .animation(.easeOut(duration: 0.45), value: showLandingTitle)

                    NavigationLink {
                        ExploreView()
                    } label: {
                        Text("Explore")
                            .font(.system(size: 44, weight: .heavy, design: .rounded))
                            .frame(maxWidth: 300)
                            .frame(height: 84)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.green)
                            )
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(showLandingActions ? 1 : 0.95)
                    .opacity(showLandingActions ? 1 : 0)
                    .offset(y: showLandingActions ? 0 : 14)
                    .animation(.easeOut(duration: 0.38), value: showLandingActions)

                    NavigationLink {
                        QuizView(instruments: instruments)
                    } label: {
                        Text("Quiz")
                            .font(.system(size: 44, weight: .heavy, design: .rounded))
                            .frame(maxWidth: 300)
                            .frame(height: 84)
                            .foregroundStyle(.black)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.yellow)
                            )
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(showLandingActions ? 1 : 0.95)
                    .opacity(showLandingActions ? 1 : 0)
                    .offset(y: showLandingActions ? 0 : 14)
                    .animation(.easeOut(duration: 0.38).delay(0.06), value: showLandingActions)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .offset(y: -180)
            }
            .toolbar(.hidden)
        }
        .onAppear {
            showLandingTitle = false
            showLandingActions = false
            showLandingTitle = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.17) {
                showLandingActions = true
            }
        }
    }
}

#Preview {
    ContentView()
}
