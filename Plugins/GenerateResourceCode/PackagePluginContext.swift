import Foundation
import PackagePlugin

protocol PackagePluginContext {
    var currentDirectoryURL: URL { get }
}

extension PluginContext: PackagePluginContext {
    var currentDirectoryURL: URL { package.directoryURL }
}

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

extension XcodePluginContext: PackagePluginContext {
    var currentDirectoryURL: URL { xcodeProject.directoryURL }
}

#endif
