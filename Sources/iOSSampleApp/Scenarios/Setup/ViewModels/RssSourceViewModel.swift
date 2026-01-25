//
//  RssSourceViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Observation
import UIKit

@Observable
final class RssSourceViewModel {
    let source: RssSource
    var isSelected = false
    private(set) var icon: UIImage?

    init(source: RssSource) {
        self.source = source

        // Load icon asynchronously if available
        if let iconUrl = source.icon {
            Task {
                await loadIcon(from: iconUrl)
            }
        }
    }

    @MainActor
    private func loadIcon(from url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                icon = image
            }
        } catch {
            // Silently fail if icon can't be loaded
            icon = nil
        }
    }
}
