//
//  UserDefaultsSettingsService
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

class UserDefaultsSettingsService: SettingsService {

    var selectedSource: RssSource? {
        get {
            let jsonDecoder = JSONDecoder()
            if let serialized = UserDefaults.standard.data(forKey: "source"), let source = try? jsonDecoder.decode(RssSource.self, from: serialized) {
                return source
            }
            return nil
        }
        set {
            let jsonEncoder = JSONEncoder()
            let serialized = try! jsonEncoder.encode(newValue)
            UserDefaults.standard.set(serialized, forKey: "source")
        }
    }
}
