// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// About
  internal static let about = L10n.tr("Localizable", "about")
  /// Add custom
  internal static let addCustom = L10n.tr("Localizable", "add_custom")
  /// Add custom source
  internal static let addCustomSource = L10n.tr("Localizable", "add_custom_source")
  /// About author
  internal static let author = L10n.tr("Localizable", "author")
  /// Back
  internal static let back = L10n.tr("Localizable", "back")
  /// Invalid RSS feed URL
  internal static let badUrl = L10n.tr("Localizable", "bad_url")
  /// Author's blog
  internal static let blog = L10n.tr("Localizable", "blog")
  /// Done
  internal static let done = L10n.tr("Localizable", "done")
  /// Feed
  internal static let feed = L10n.tr("Localizable", "feed")
  /// Used libraries
  internal static let libraries = L10n.tr("Localizable", "libraries")
  /// Logo URL
  internal static let logoUrl = L10n.tr("Localizable", "logo_url")
  /// Network problem has occured
  internal static let networkProblem = L10n.tr("Localizable", "network_problem")
  /// Optional
  internal static let `optional` = L10n.tr("Localizable", "optional")
  /// Pull to refresh
  internal static let pullToRefresh = L10n.tr("Localizable", "pull_to_refresh")
  /// RSS URL
  internal static let rssUrl = L10n.tr("Localizable", "rss_url")
  /// Select source
  internal static let selectSource = L10n.tr("Localizable", "select_source")
  /// Title
  internal static let title = L10n.tr("Localizable", "title")
  /// Url
  internal static let url = L10n.tr("Localizable", "url")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
