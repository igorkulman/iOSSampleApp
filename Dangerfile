require "json"

# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_title.include? "#trivial"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"
warn("PR is classed as Work in Progress") if github.pr_title.include? "WIP"

# Message on Carthage changes
message("This PR changes Carthage dependencies") if git.modified_files.include? "Sources/Cartfile" 

# Message on configuration changes
message("This PR changes CI dendency gems") if git.modified_files.include? "Gemfile"
message("This PR changes Fastlane configuration") if git.modified_files.include? "fastlane/Fastfile"
message("This PR changes Danger configuration") if git.modified_files.include? "Dangerfile"

# Warn when there is a big PR
warn("This PR seems bigger than it should be!") if git.lines_of_code > 500

# Checking for missing strings
`support/verify-string-files -master Sources/iOSSampleApp/Resources/Base.lproj/Localizable.strings  -warning-level warning &> verify-string-files.txt`
result = File.readlines('verify-string-files.txt')
if result.count > 0
    message = "### Missing translations\n\n".dup

    message << "Language | Key | \n"
    message << "| --- | ----- \n"
    result.each { |line|    
        index = line.index(": warning:") + 11
        line = line[index...-1]
        lang = line.rpartition(' ').last.sub(".lproj", "").upcase()
        if lang == "DE"
            lang = "🇩🇪  DE"
        elsif lang == "ES"
            lang = "🇪🇸  ES"
        end
        key = line.rpartition(' ').first.sub("is missing in", "")
        message << "#{lang} | #{key} \n"
    }
    markdown message
end
`rm verify-string-files.txt`