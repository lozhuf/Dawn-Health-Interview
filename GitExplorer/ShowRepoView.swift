//
//  ShowRepoView.swift
//  GitExplorer
//
//  Created by Laurie Hufford on 13/08/2024.
//

import SwiftUI

struct ShowRepoView: View {
    
    let repo: Repository
    
    func missingRepoIconView() -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color(red: 233/255, green: 250/255, blue: 250/255))
            .overlay(content: {
                Image("missing-repo-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(28)
            })
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            AsyncImage(
                url: repo.iconURL,
                transaction: .init(animation: .default)
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if phase.error != nil {
                    missingRepoIconView()
                } else {
                    Color(red: 233/255, green: 250/255, blue: 250/255)
                }
            }
            .cornerRadius(6)
            .frame(width: 100, height: 100)
            .padding(.bottom, 14)
             
            Text("\(repo.name) / \(repo.orgName)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("PrimaryText"))
                .padding(.bottom, 6)
            Text("\(repo.language)")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color("SecondaryText"))
                .padding(.bottom, 6)
            
            Spacer()
        }
    }
}

#Preview {
    ShowRepoView(repo: .dummy_a)
}
