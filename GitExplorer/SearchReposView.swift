//
//  SearchReposView.swift
//  GitExplorer
//
//  Created by Laurie Hufford on 13/08/2024.
//

import SwiftUI


class SearchReposViewModel: ObservableObject {
    
    @Published var repos: [Repository] = [] //[.dummy_a, .dummy_b]
    
    init() {
        
    }
}

/**
 TODO:
 - Plural formatter for results count
 
 */

struct SearchReposView: View {
    
    @StateObject var viewModel: SearchReposViewModel = SearchReposViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.repos.isEmpty {
                    emptyState()
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("\(viewModel.repos.count) Results")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.dhSecondaryText)
                        
                        VStack(spacing: 24) {
                            ForEach(viewModel.repos) { repo in
                                repoRow(repo: repo)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    func repoRow(repo: Repository) -> some View {
        HStack(alignment: .center, spacing: 16) {
            RepoIconView(url: repo.iconURL)
                .frame(width: 42, height: 42)
                .cornerRadius(6)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(repo.name) / \(repo.orgName)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.dhPrimaryText)
                    
                Text("\(repo.description)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.dhSecondaryText)
            }
            .lineLimit(1)
            
            Spacer(minLength: 0)
        }
    }
    
    @ViewBuilder
    func emptyState() -> some View {
        VStack(spacing: 0) {
            Image("emptysearch")
                .padding(.leading, 4) // to fix icon centering
                .padding(.bottom, 30)
            
            Text("A little empty")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.dhPrimaryText)
                .padding(.bottom, 8)
            
            Text("Search for a repository and save it as favourite")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.dhSecondaryText)
        }
        .multilineTextAlignment(.center)
        .frame(width: 180)
    }
}

#Preview {
    SearchReposView(viewModel: SearchReposViewModel())
}
