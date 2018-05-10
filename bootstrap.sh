#!/bin/bash

brew update
brew outdated carthage || brew upgrade carthage
brew outdated swiftlint || brew upgrade swiftlint
brew outdated swiftgen || brew upgrade swiftgen
brew cask install fastlane

brew bootstrap