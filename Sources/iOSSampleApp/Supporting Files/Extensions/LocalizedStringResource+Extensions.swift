//
//  LocalizedStringResource+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 24.12.2025.
//  Copyright © 2025 Igor Kulman. All rights reserved.
//

import Foundation

extension LocalizedStringResource {
    // MARK: - About
    static let about = LocalizedStringResource("about")
    static let author = LocalizedStringResource("author")
    static let blog = LocalizedStringResource("blog")
    static let libraries = LocalizedStringResource("libraries")

    // MARK: - Setup
    static let addCustom = LocalizedStringResource("add_custom")
    static let addCustomSource = LocalizedStringResource("add_custom_source")
    static let selectSource = LocalizedStringResource("select_source")
    static let done = LocalizedStringResource("done")

    // MARK: - Form Fields
    static let title = LocalizedStringResource("title")
    static let url = LocalizedStringResource("url")
    static let rssUrl = LocalizedStringResource("rss_url")
    static let logoUrl = LocalizedStringResource("logo_url")
    static let optional = LocalizedStringResource("optional")

    // MARK: - Navigation
    static let back = LocalizedStringResource("back")

    // MARK: - Feed
    static let pullToRefresh = LocalizedStringResource("pull_to_refresh")
    static let emptyResponse = LocalizedStringResource("empty_response")
    static let networkProblem = LocalizedStringResource("network_problem")
}
