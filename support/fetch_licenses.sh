DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
swift $DIR/fetch_licenses.swift $DIR/../Sources/Cartfile.resolved $DIR/../Sources/iOSSampleApp/Data
