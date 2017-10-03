//
//  SettingsService.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

class SettingsService {
    
    init() {
        UserDefaults.standard.register(defaults: ["isSetupComplete" : false])
    }
    
    var isSetupComplete: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isSetupComplete")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isSetupComplete")
        }
    }    
}
