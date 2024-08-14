//
//  MainAppView.swift
//  GitExplorer
//
//  Created by Laurie Hufford on 13/08/2024.
//

import SwiftUI

/**
 TODO:
 - Splash screen graphic in launch screen
 - matched geometry transition for logo icon
 */
struct MainAppView: View {
    var splashScreenDuration: TimeInterval = 3
    @State var selectedRepo: Repository?
    @State private var splashScreenShown = false
    
    var body: some View {
        if splashScreenShown {
            ZStack {
                
                SearchReposView(selectedRepo: $selectedRepo)
                    .opacity(selectedRepo == nil ? 1 : 0)
                
                if let selectedRepo {
                    VStack(spacing: 12) {
                        // navbar
                        HStack {
                            Button {
                                withAnimation {
                                    self.selectedRepo = nil
                                }
                            } label: {
                                Image("backarrow")
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        
                        // repo details
                        ShowRepoView(repo: selectedRepo)
                    }
                    .background(Color.white)
                }
            }
        } else {
            SplashView()
                .onAppear {
                    Task {
                        try await Task.sleep(for: .seconds(splashScreenDuration))
                        withAnimation {
                            self.splashScreenShown = true
                        }
                    }
                }
        }
    }
}

#Preview {
    MainAppView(splashScreenDuration: 0, selectedRepo: nil)
}
