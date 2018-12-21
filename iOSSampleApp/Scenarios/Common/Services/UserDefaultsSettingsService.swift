//
//  UserDefaultsSettingsService
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Defaults
import Foundation

/**
App specific settings implemented using user defaults
 */
final class UserDefaultsSettingsService: SettingsService {
    /**
     Currently selected RSS source
     */
    var selectedSource: RssSource? {
        get {
            return defaults[.source]
        }
        set {
            defaults[.source] = newValue
        }
    }
}

/**
Defining the source key for the Defaults library
 */
extension Defaults.Keys {
    static let source = Defaults.OptionalKey<RssSource>("source")
}
