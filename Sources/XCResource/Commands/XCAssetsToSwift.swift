import Foundation
import ArgumentParser
import AssetKeyGen
import XCResourceUtil

private let headerComment = """
// Generated from \(ProcessInfo.processInfo.processName).
// Do Not Edit Directly!
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
    
    @Option(help: ArgumentHelp(valueName: AssetType.allValueStrings.joined(separator: "|")))
    var assetType: AssetType = .imageSet
    
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
            assetType: assetType,
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
