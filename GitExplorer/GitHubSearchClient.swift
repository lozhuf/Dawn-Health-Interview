//
//  GitHubSearchClient.swift
//  GitExplorer
//
//  Created by Laurie Hufford on 14/08/2024.
//

import Foundation

struct GitHubSearchClient {
    var search: (_ query: String) async throws -> [Repository]
}

/**
 TODO:
 - Support passing custom URLSession (+ caching options etc)
 - Getting release version from response (sub-url query when opening details?)
 - Passing token for auth?
 - Should split full_name into orgName, rather than using owner?
 - Add scrolled-pagination to results
 */

extension GitHubSearchClient {
    
    static func live() -> Self {
        Self { query in
            var url = URL(string: "https://api.github.com/search/repositories")!
            url.append(queryItems: [URLQueryItem(name: "q", value: query)])
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(GHRepoSearchResponse.self, from: data)
            
            return response.items.map(Repository.init(response:))
        }
    }
}

extension GitHubSearchClient{
    static func constant(result: Result<[Repository], Error>) -> Self {
        Self { query in
            try result.get()
        }
    }
    
    func delayed(by delay: TimeInterval) -> Self {
        var copy = self
        let search = self.search
        copy.search = { query in
            try await Task.sleep(for: .seconds(delay))
            return try await search(query)
        }
        return copy
    }
    
    func printingErrors(using toStr: @escaping (String, Error) -> String = { "❌ Search '\($0)' Failed: \($1.localizedDescription)" }) -> Self {
        var copy = self
        let search = self.search
        copy.search = { query in
            do {
                return try await search(query)
            } catch {
                print(toStr(query, error))
                throw error
            }
        }
        return copy
    }
}

struct GHRepoSearchResponse: Decodable {
    struct Repo: Decodable {
        
        struct Owner: Decodable {
            var login: String
            var avatar_url: URL?
        }
        
        var id: Int
        var name: String
        var full_name: String
        var owner: Owner?
        var description: String?
        var language: String?
        var forks_count: Int
        var open_issues_count: Int
        var stargazers_count: Int
    }
    
    var items: [Repo]
}

extension Repository {
    init(response: GHRepoSearchResponse.Repo) {
        self.init(
            id: response.id,
            name: response.name,
            iconURL: response.owner?.avatar_url,
            orgName: response.owner?.login ?? "",
            description: response.description,
            language: response.language,
            forkCount: response.forks_count,
            openIssuesCount: response.open_issues_count,
            stargazersCount: response.stargazers_count,
            lastReleaseVersion: nil
        )
    }
}
