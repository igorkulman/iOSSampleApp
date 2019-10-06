//
//  SettingsService.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 20/02/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation

/**
App specific settings
 */
protocol SettingsService: AnyObject {
    /**
     Currently selected RSS source
     */
    var selectedSource: RssSource? { get set }
}
