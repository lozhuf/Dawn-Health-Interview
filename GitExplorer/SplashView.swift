//
//  ContentView.swift
//  GitExplorer
//
//  Created by Laurie Hufford on 13/08/2024.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        Image("logo")
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
    }
}

#Preview {
    SplashView()
}
