#!/usr/bin/env xcrun swift

import Cocoa

func loadResolvedCartfile(file: String) throws -> String {
    let string = try String(contentsOfFile: file, encoding: String.Encoding.utf8)
    return string
}

func parseResolvedCartfile(contents: String) -> [CartfileEntry] {
    let lines = contents.components(separatedBy: "\n")
    return lines.filter({ $0.utf16.count > 0 }).map { CartfileEntry(line: $0) }
}

struct CartfileEntry: CustomStringConvertible {
    let name: String, version: String
    var license: String?

    init(line: String) {
        let line = line.replacingOccurrences(of: "github ", with: "")
        let components = line.components(separatedBy: "\" \"")
        name = components[0].replacingOccurrences(of: "\"", with: "")
        version = components.count > 1 ? components[1].replacingOccurrences(of: "\"", with: "") : ""
    }

    var projectName: String {
        return name.components(separatedBy: "/")[1]
    }

    var description: String {
        return ([name, version]).joined(separator: " ")
    }

    func fetchLicense() -> (String, String) {
        var licenseName = ""
        var licenseContent = ""
        let semaphore = DispatchSemaphore(value: 0)

        print("Fetching license name for \(name) ...")

        var request = URLRequest(url: URL(string: "https://api.github.com/repos/\(name)/license")!)
        request.addValue("application/vnd.github.drax-preview+json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in

            if let response = response as? HTTPURLResponse {
                if response.statusCode == 404 {
                    semaphore.signal()
                    return
                }
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                if let info = json["license"] as? [String: Any] {
                    licenseName = info["name"] as? String ?? ""
                }
                if let content = json["content"] as? String {
                    let normalized = content.replacingOccurrences(of: "\n", with: "")

                    if let decodedData = Data(base64Encoded: normalized, options: NSData.Base64DecodingOptions(rawValue: 0)), let decodedString = String(data: decodedData, encoding: String.Encoding.utf8) {
                        licenseContent = decodedString
                    }
                }
            } catch let error as NSError {
                print(error)
            }

            semaphore.signal()
        })
        task.resume()

        _ = semaphore.wait(timeout: .distantFuture)
        return (licenseName, licenseContent)
    }
}

var c = 0
if CommandLine.arguments.count >= 3 {
    let outputDirectory = CommandLine.arguments[CommandLine.arguments.count - 1]
    var error: NSError?
    do {
        var entries: [CartfileEntry] = []
        for i in 1 ... CommandLine.arguments.count - 2 {
            let content = try loadResolvedCartfile(file: CommandLine.arguments[i])
            let fileEntries = parseResolvedCartfile(contents: content)
            entries.append(contentsOf: fileEntries.filter({ !entries.map({ $0.name }).contains($0.name) }))
        }
        let licenses = entries.map({ (entry: CartfileEntry) -> [String: Any] in
            let (licenseName, licenseContent) = entry.fetchLicense()
            return ["title": entry.projectName, "text": licenseContent, "license": licenseName]
        })
        let fileName = (outputDirectory as NSString).appendingPathComponent("Licenses.plist")
        (licenses as NSArray).write(toFile: fileName, atomically: true)
        print("Super awesome! Your licenses are at \(fileName) 🍻")
    } catch {
        print(error)
    }
} else {
    print("USAGE: ./fetch_licenses Cartfile.resolved output_directory/")
}
