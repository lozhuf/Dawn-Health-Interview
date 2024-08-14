//
//  ShowRepoView.swift
//  GitExplorer
//
//  Created by Laurie Hufford on 13/08/2024.
//

import SwiftUI

/**
 TODO:
 - LineWidth tied to screen density
 */
struct ShowRepoView: View {
    
    let repo: Repository
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                RepoIconView(url: repo.iconURL)
                    .cornerRadius(6)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 14)
                
                Text("\(repo.name) / \(repo.orgName)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.dhPrimaryText)
                    .padding(.bottom, 6)
                if let lang = repo.language {
                    Text("\(lang)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.dhSecondaryText)
                        .padding(.bottom, 30)
                }
                
                VStack(spacing: 0) {
                    dataRow(title: "Forks", value: "\(repo.forkCount.formatted())")
                    
                    dataRow(title: "Issues", value: "\(repo.openIssuesCount.formatted())")
                    
                    dataRow(title: "Starred by", value: "\(repo.stargazersCount.formatted())", showDivider: repo.lastReleaseVersion != nil)
                    
                    if let version = repo.lastReleaseVersion {
                        dataRow(title: "Last release version", value: "\(version)", showDivider: false)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 6) // on top of the dataRow's padding
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.dhDivider, lineWidth: 0.5)
                )
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .background(Color.white)
    }
    
    @ViewBuilder
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
    
    @ViewBuilder
    func dataRow(title: String, value: String, showDivider: Bool = true) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(title)
            Spacer()
            Text(value)
        }
        .font(.system(size: 14, weight: .regular))
        .foregroundColor(.dhPrimaryText)
        .padding(.vertical, 14)
        
        if showDivider {
            Rectangle()
                .fill(Color.dhDivider)
                .frame(height: 0.5)
        }
    }
}

#Preview {
    ShowRepoView(repo: .dummy_b)
}
