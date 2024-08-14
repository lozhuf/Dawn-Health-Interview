//
//  MainAppView.swift
//  GitExplorer
//
//  Created by Laurie Hufford on 13/08/2024.
//

import SwiftUI

/**
 TODO:
 - Splash screen with timer
 - matched geometry transition for logo icon
 */
struct MainAppView: View {
    @State var selectedRepo: Repository?
    
    var body: some View {
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
    }
}

#Preview {
    MainAppView(selectedRepo: nil)
}
