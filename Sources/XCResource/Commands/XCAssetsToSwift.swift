import Foundation
import ArgumentParser
import AssetKeyGen
import XCResourceUtil

private let headerComment = """
// Generated from \(ProcessInfo.processInfo.processName).
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
    
    // MARK: - Arguments
    
    @Option(name: .customLong("xcassets-path"))
    var assetCatalogPaths: [String]
    
    @Option(
        name: .customLong("asset-type"),
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Asset type to export.",
            discussion: "If not specified, all asset types are exported. For more information "
                + "about possible types, see \(catalogDocumentURLString)",
            valueName: AssetType.someValueStrings.joined(separator: "|")))
    var assetTypes: [AssetType] = []
    
    @Option var swiftPath: String
    
    @Option var swiftTypeName: String
    
    @Flag var excludeTypeDeclation: Bool = false
    
    // MARK: - Run
    
    mutating func run() throws {
        let codes = try generateCodes()
        
        try writeCodes(codes)
    }
    
    private func generateCodes() throws -> AssetKeyGenerator.CodeResult {
        let request = AssetKeyGenerator.CodeRequest(
            assetCatalogURLs: assetCatalogPaths.map({ URL(fileURLWithExpandingTildeInPath: $0) }),
            assetTypes: Set(assetTypes.isEmpty ? AssetType.allCases : assetTypes),
            keyTypeName: swiftTypeName)
        
        return try AssetKeyGenerator().generate(for: request)
    }
    
    private func writeCodes(_ codes: AssetKeyGenerator.CodeResult) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        var stream = try TextFileOutputStream(forWritingTo: tempFileURL)
        
        print(headerComment, terminator: "\n\n", to: &stream)
        
        if !excludeTypeDeclation {
            print(codes.typeDeclaration, terminator: "\n\n", to: &stream)
        }
        
        print(codes.keyDeclarations, to: &stream)
        
        try stream.close()
        try FileManager.default.compareAndReplaceItem(at: swiftPath, withItemAt: tempFileURL)
    }
}
