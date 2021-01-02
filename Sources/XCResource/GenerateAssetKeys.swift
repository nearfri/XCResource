import Foundation
import ArgumentParser
import AssetKeyGen
import XCResourceUtil

private let headerComment = """
// Generated from \(ProcessInfo.processInfo.processName).
// Do Not Edit Directly!
"""

extension AssetType: ExpressibleByArgument {
    public init?(argument: String) {
        switch argument {
        case "image":   self = .imageSet
        case "color":   self = .colorSet
        case "symbol":  self = .symbolSet
        default:        return nil
        }
    }
    
    public var defaultValueDescription: String {
        return "image"
    }
    
    public static var allValueStrings: [String] {
        return ["image", "color", "symbol"]
    }
}

struct GenerateAssetKeys: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        abstract: "Asset Catalog로부터 키 파일 생성",
        discussion: """
            Xcode Asset Catalog(.xcassets)에서 리소스 이름을 추출해서 키 파일을 생성한다.
            추출한 키 파일은 앱에서 리소스 로딩에 사용할 수 있다.
            """)
    
    // MARK: - Arguments
    
    @Option(name: .customLong("input-xcassets"))
    var inputXCAssets: [String]
    
    @Option(help: ArgumentHelp(valueName: AssetType.allValueStrings.joined(separator: "|")))
    var assetType: AssetType = .imageSet
    
    @Option var keyTypeName: String
    
    @Option(help: "<key-list-file>에 '@testable import <module-name>' 추가")
    var moduleName: String?
    
    @Flag var excludeTypeDeclation: Bool = false
    
    @Option var keyDeclFile: String
    
    @Option var keyListFile: String?
    
    // MARK: - Run
    
    mutating func run() throws {
        let codes = try generateCodes()
        
        try writeKeyDeclFile(from: codes)
        
        try writeKeyListFileIfNeeded(from: codes)
    }
    
    private func generateCodes() throws -> AssetKeyGenerator.CodeResult {
        let request = AssetKeyGenerator.CodeRequest(
            catalogURLs: inputXCAssets.map({ URL(fileURLWithExpandingTildeInPath: $0) }),
            assetType: assetType,
            keyTypeName: keyTypeName)
        
        return try AssetKeyGenerator().generate(for: request)
    }
    
    private func writeKeyDeclFile(from codes: AssetKeyGenerator.CodeResult) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        var stream = try TextFileOutputStream(forWritingTo: tempFileURL)
        
        print(headerComment, terminator: "\n\n", to: &stream)
        
        if !excludeTypeDeclation {
            print(codes.typeDeclaration, terminator: "\n\n", to: &stream)
        }
        
        print(codes.keyDeclarations, to: &stream)
        
        try stream.close()
        try FileManager.default.compareAndReplaceItem(at: keyDeclFile, withItemAt: tempFileURL)
    }
    
    private func writeKeyListFileIfNeeded(from codes: AssetKeyGenerator.CodeResult) throws {
        guard let keyListFile = keyListFile else { return }
        
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        var stream = try TextFileOutputStream(forWritingTo: tempFileURL)
        
        print(headerComment, terminator: "\n\n", to: &stream)
        
        if let moduleName = moduleName {
            print("@testable import \(moduleName)", terminator: "\n\n", to: &stream)
        }
        
        print(codes.keyList, to: &stream)
        
        try stream.close()
        try FileManager.default.compareAndReplaceItem(at: keyListFile, withItemAt: tempFileURL)
    }
}
