//
//  UserDefaultsSettingsService
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Defaults

class UserDefaultsSettingsService: SettingsService {
    var selectedSource: RssSource? {
        get {
            return defaults[.source]
        }
        set {
            defaults[.source] = newValue
        }
    }
}

extension Defaults.Keys {
    static let source = Defaults.OptionalKey<RssSource>("source")
}
