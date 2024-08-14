//
//  SearchReposView.swift
//  GitExplorer
//
//  Created by Laurie Hufford on 13/08/2024.
//

import Combine
import SwiftUI

struct GitHubSearchClient {
    var search: (_ query: String) async throws -> [Repository]
}

extension GitHubSearchClient {
    static func dummy(delay: TimeInterval) -> Self {
        Self { query in
            try await Task.sleep(for: .seconds(delay))
            return [.dummy_a, .dummy_b]
        }
    }
}

/**
 TODO:
 - Plural formatter for results count
 - Use Task instead of reqId for cancelling tasks
 - Real live GH client
 */

@MainActor
class SearchReposViewModel: ObservableObject {
    
    @Published var repos: [Repository] = []
    @Published var searchInput: String = ""
    
    private let searchClient: GitHubSearchClient
    private var cancellables: Set<AnyCancellable> = []
    
    init(searchClient: GitHubSearchClient = .dummy(delay: 0.9)) {
        self.searchClient = searchClient
        
        // start watching the search field, and debounce the input
        $searchInput
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] input in
                self?.searchInputChanged(input: input)
            }
            .store(in: &cancellables)
    }
    
    private var searchReqId: Int = 0
    
    func searchInputChanged(input: String) {
        guard input.count >= 3 else {
            withAnimation {
                self.repos = []
            }
            return
        }
        
        Task { [weak self] in
            self?.searchReqId += 1
            let currReqId = self?.searchReqId
            let results = try? await self?.searchClient.search(input)
            
            guard currReqId == self?.searchReqId else {
                return
            }
            withAnimation {
                self?.repos = results ?? []
            }
        }
    }
}

struct SearchReposView: View {
    
    @StateObject var viewModel: SearchReposViewModel = SearchReposViewModel()
    
    @Binding var selectedRepo: Repository?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Repository library")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.dhPrimaryText)
                
                HStack(spacing: 15) {
                    Image("searchicon")
                    
                    TextField(
                        "Search for repository",
                        text: $viewModel.searchInput
                    )
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.dhPrimaryText)
                .padding(14)
                .background(Color.dhSearchField)
                .cornerRadius(6)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 30)
            
            ScrollView {
                if viewModel.repos.isEmpty {
                    emptyState()
                        .padding(.top, 120)
                        .frame(maxWidth: .infinity)
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
                    .padding(.horizontal, 20)
                }
            }
        }
        .background(Color.white)
    }
    
    @ViewBuilder
    func repoRow(repo: Repository) -> some View {
        Button {
            withAnimation {
                self.selectedRepo = repo
            }
        } label: {
            HStack(alignment: .center, spacing: 16) {
                RepoIconView(url: repo.iconURL)
                    .cornerRadius(6)
                    .frame(width: 42, height: 42)
                
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
    SearchReposView(viewModel: SearchReposViewModel(), selectedRepo: .constant(nil))
}
