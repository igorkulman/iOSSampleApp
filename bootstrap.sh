#!/bin/bash

brew update
brew ls --versions carthage && brew upgrade carthage || brew install carthage
brew ls --versions swiftlint && brew upgrade swiftlint || brew install swiftlint
brew ls --versions swiftgen && brew upgrade swiftgen || brew install swiftgen
brew ls --versions xcodegen && brew upgrade xcodegen || brew install xcodegen
sudo gem install fastlane -NV

fastlane carthage_bootstrap
