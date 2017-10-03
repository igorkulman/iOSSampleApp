//
//  AppDelegate+Setup.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import CleanroomLogger
import Swinject
import SwinjectAutoregistration

extension AppDelegate {
    
    func setupLogging() {
        var configs = [LogConfiguration]()
        
        // create a recorder for logging to stdout & stderr
        // and add a configuration that references it
        let stderr = StandardStreamsLogRecorder(formatters: [XcodeLogFormatter()])
        configs.append(BasicLogConfiguration(minimumSeverity: .debug, recorders: [stderr]))
        
        // create a recorder for logging via OSLog (if possible)
        // and add a configuration that references it
        if let osLog = OSLogRecorder(formatters: [ReadableLogFormatter()]) {
            // the OSLogRecorder initializer will fail if running on
            // a platform that doesn’t support the os_log() function
            configs.append(BasicLogConfiguration(recorders: [osLog]))
        }
        
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent("logs")
        
        // create a configuration for a 15-day rotating log directory
        let fileCfg = RotatingLogFileConfiguration(minimumSeverity: .debug,
                                                   daysToKeep: 15,
                                                   directoryPath: logsPath!.path,
                                                   formatters: [ReadableLogFormatter()])
        
        // crash if the log directory doesn’t exist yet & can’t be created
        try! fileCfg.createLogDirectory()
        
        configs.append(fileCfg)
        
        // enable logging using the LogRecorders created above
        Log.enable(configuration: configs)
    }
    
    func setupDependencies() {
        Log.debug?.message("Registering dependencies")
        
        // services
        container.autoregister(SettingsService.self, initializer: SettingsService.init).inObjectScope(ObjectScope.container)
        container.autoregister(NotificationService.self, initializer: NotificationService.init).inObjectScope(ObjectScope.container)
        
        //viewmodels
        container.autoregister(SourceSelectionViewModel.self, initializer: SourceSelectionViewModel.init)
        container.autoregister(CustomSourceViewModel.self, initializer: CustomSourceViewModel.init)
        
        //view controllers
        container.storyboardInitCompleted(SourceSelectionViewController.self) {
            r, c in c.viewModel = r.resolve(SourceSelectionViewModel.self)
        }
        container.storyboardInitCompleted(CustomSourceViewController.self) {
            r, c in c.viewModel = r.resolve(CustomSourceViewModel.self)
        }
    }
}
