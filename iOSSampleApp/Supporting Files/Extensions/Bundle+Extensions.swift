//
//  Bundle+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

extension Bundle {
    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }

    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }

    var appBuild: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }

    func loadFile(filename fileName: String) -> Data? {
        let parts = fileName.components(separatedBy: ".")
        if let url = Bundle.main.url(forResource: parts[0], withExtension: parts[1]), let data = try? Data(contentsOf: url) {
            return data
        } else {
            return nil
        }
    }
}
