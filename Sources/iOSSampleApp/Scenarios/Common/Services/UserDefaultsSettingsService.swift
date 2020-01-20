//
//  UserDefaultsSettingsService
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

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
            let coder = JSONDecoder()
            guard let value = UserDefaults.standard.data(forKey: "source"), let source = try? coder.decode(RssSource.self, from: value) else {
                return nil
            }

            return source
        }
        set {
            guard let value = newValue else {
                UserDefaults.standard.removeObject(forKey: "source")
                return
            }

            let coder = JSONEncoder()
            guard let data = try? coder.encode(value) else {
                fatalError("Encoding RssSource should never fail")
            }

            UserDefaults.standard.set(data, forKey: "source")
        }
    }
}
