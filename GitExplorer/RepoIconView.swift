//
//  RepoIconView.swift
//  GitExplorer
//
//  Created by Laurie Hufford on 13/08/2024.
//

import SwiftUI

struct RepoIconView: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(
            url: url,
            transaction: .init(animation: .default)
        ) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if url == nil || phase.error != nil {
                missingRepoIconView() // no url or an error
            } else {
                // loading placeholder
                Color(red: 233/255, green: 250/255, blue: 250/255)
            }
        }
    }
    
    @ViewBuilder
    func missingRepoIconView() -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color(red: 233/255, green: 250/255, blue: 250/255))
            .overlay(content: {
                Image("missing-repo-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            })
    }
}

#Preview {
    RepoIconView(url: nil)
        .frame(width: 42, height: 42)
        .cornerRadius(6)
}
