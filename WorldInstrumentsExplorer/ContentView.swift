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
            GeometryReader { proxy in
                let size = proxy.size
                let fullLayout = size.width >= 1200 && size.height >= 820
                let scale = fullLayout ? 1.0 : min(size.width / 1200, size.height / 820)
                let clampedScale = max(0.72, min(1.0, scale))
                let titleSize = 72 * clampedScale
                let buttonFontSize = 44 * clampedScale
                let buttonMaxWidth = 300 * clampedScale
                let buttonHeight = 84 * clampedScale
                let verticalOffset = fullLayout ? -180.0 : -180.0 * clampedScale

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

                    VStack(spacing: 20 * clampedScale) {
                        Spacer()

                        Text("Instrument Atlas")
                            .font(.custom("Times New Roman", size: titleSize))
                            .italic()
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .foregroundStyle(.black)
                            .shadow(color: .black.opacity(0.8), radius: 6, x: 0, y: 2)
                            .padding(.bottom, 8 * clampedScale)
                            .scaleEffect(showLandingTitle ? 1 : 0.95)
                            .opacity(showLandingTitle ? 1 : 0)
                            .offset(y: showLandingTitle ? 0 : 18)
                            .animation(.easeOut(duration: 0.45), value: showLandingTitle)

                        NavigationLink {
                            ExploreView()
                        } label: {
                            Text("Explore")
                                .font(.system(size: buttonFontSize, weight: .heavy, design: .rounded))
                                .frame(maxWidth: buttonMaxWidth)
                                .frame(height: buttonHeight)
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
                                .font(.system(size: buttonFontSize, weight: .heavy, design: .rounded))
                                .frame(maxWidth: buttonMaxWidth)
                                .frame(height: buttonHeight)
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
                    .padding(.horizontal, 24 * clampedScale)
                    .padding(.bottom, 32 * clampedScale)
                    .offset(y: verticalOffset)
                }
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
