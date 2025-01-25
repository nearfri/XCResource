import Foundation
import ArgumentParser
import AssetKeyGen
import XCResourceUtil

private let headerComment = """
// This file was generated by xcresource
// Do Not Edit Directly!
"""

private let catalogDocumentURLString = """
https://developer.apple.com/library/archive/documentation/Xcode/Reference/\
xcode_ref-Asset_Catalog_Format/AssetTypes.html
"""

struct XCAssetsToSwift: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "xcassets2swift",
        abstract: "Asset Catalog로부터 키 파일 생성",
        discussion: """
            Xcode Asset Catalog(.xcassets)에서 리소스 이름을 추출해서 키 파일을 생성한다.
            추출한 키 파일은 앱에서 리소스 로딩에 사용할 수 있다.
            """)
    
    // MARK: - Default values
    
    enum Default {
        static let assetTypes: [AssetType] = []
        static let excludesTypeDeclaration: Bool = false
    }
    
    // MARK: - Arguments
    
    @Option(name: .customLong("xcassets-path"))
    var assetCatalogPaths: [String]
    
    @Option(name: .customLong("asset-type"),
            parsing: .upToNextOption,
            help: ArgumentHelp(
                "Asset type to export.",
                discussion: "If not specified, all asset types are exported. For more "
                    + "information about possible types, see \(catalogDocumentURLString)",
                valueName: AssetType.joinedAllValuesString))
    var assetTypes: [AssetType] = Default.assetTypes
    
    @Option var swiftPath: String
    
    @Option var resourceTypeName: String
    
    @Option(help: ArgumentHelp(valueName: AccessLevel.joinedAllValuesString))
    var accessLevel: AccessLevel?
    
    @Flag(name: .customLong("exclude-type-declaration"))
    var excludesTypeDeclaration: Bool = Default.excludesTypeDeclaration
    
    // MARK: - Run
    
    mutating func run() throws {
        let codes = try generateCodes()
        
        try writeCodes(codes)
    }
    
    private func generateCodes() throws -> AssetKeyGenerator.Result {
        let request = AssetKeyGenerator.Request(
            assetCatalogURLs: assetCatalogPaths.map({ URL(fileURLWithExpandingTildeInPath: $0) }),
            assetTypes: Set(assetTypes.isEmpty ? AssetType.allCases : assetTypes),
            resourceTypeName: resourceTypeName,
            accessLevel: accessLevel?.rawValue)
        
        return try AssetKeyGenerator().generate(for: request)
    }
    
    private func writeCodes(_ codes: AssetKeyGenerator.Result) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        var stream = try TextFileOutputStream(forWritingTo: tempFileURL)
        
        print(headerComment, terminator: "\n\n", to: &stream)
        
        if !excludesTypeDeclaration {
            print(codes.typeDeclaration, terminator: "\n\n", to: &stream)
        }
        
        print(codes.keyDeclarations, to: &stream)
        
        try stream.close()
        try FileManager.default.compareAndReplaceItem(at: swiftPath, withItemAt: tempFileURL)
    }
}
