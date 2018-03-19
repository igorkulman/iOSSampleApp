// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
    /// About
    static let about = L10n.tr("Localizable", "about")
    /// Add custom
    static let addCustom = L10n.tr("Localizable", "add_custom")
    /// Add custom source
    static let addCustomSource = L10n.tr("Localizable", "add_custom_source")
    /// About author
    static let author = L10n.tr("Localizable", "author")
    /// Back
    static let back = L10n.tr("Localizable", "back")
    /// Invalid RSS Url
    static let badUrl = L10n.tr("Localizable", "bad_url")
    /// Author's blog
    static let blog = L10n.tr("Localizable", "blog")
    /// Done
    static let done = L10n.tr("Localizable", "done")
    /// Feed
    static let feed = L10n.tr("Localizable", "feed")
    /// Used libraries
    static let libraries = L10n.tr("Localizable", "libraries")
    /// Logo URL
    static let logoUrl = L10n.tr("Localizable", "logo_url")
    /// Network problem has occured
    static let networkProblem = L10n.tr("Localizable", "network_problem")
    /// Optional
    static let optional = L10n.tr("Localizable", "optional")
    /// Pull to refresh
    static let pullToRefresh = L10n.tr("Localizable", "pull_to_refresh")
    /// RSS URL
    static let rssUrl = L10n.tr("Localizable", "rss_url")
    /// Select source
    static let selectSource = L10n.tr("Localizable", "select_source")
    /// Title
    static let title = L10n.tr("Localizable", "title")
    /// Url
    static let url = L10n.tr("Localizable", "url")
}

// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

private final class BundleToken {}
