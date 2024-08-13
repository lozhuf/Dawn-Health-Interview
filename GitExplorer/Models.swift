//
//  Models.swift
//  GitExplorer
//
//  Created by Laurie Hufford on 13/08/2024.
//

import Foundation

struct Repository: Equatable, Identifiable {
    var id: String
    var name: String
    var iconURL: URL?
    var orgName: String
    var description: String
    var language: String
    var forkCount: Int
    var openIssuesCount: Int
    var stargazersCount: Int
    var lastReleaseVersion: String
}

extension Repository {
    static let dummy_a = Repository(id: "dummy-a", name: "strapi", iconURL: URL(string: "https://avatars.githubusercontent.com/u/19872173?s=200&v=4"), orgName: "strapi", description: "🚀 Strapi is the leading open-source headless CMS. It’s 100% JavaScript/TypeScript, fully customizable and developer-first.", language: "JavaScript", forkCount: 203, openIssuesCount: 266, stargazersCount: 30127, lastReleaseVersion: "3.1.6")
    static let dummy_b = Repository(id: "dummy-b", name: "strapdown", iconURL: nil, orgName: "arturadib", description: "Instant and elegant Markdown documents in the browser", language: "JavaScript", forkCount: 12, openIssuesCount: 0, stargazersCount: 127, lastReleaseVersion: "4.2")
}
