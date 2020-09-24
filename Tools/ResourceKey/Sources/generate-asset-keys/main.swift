import Foundation
import ArgumentParser
import AssetKeyGen
import Util

// 주석도 넣어줘야 함
// 모듈 이름도 있으면 @test import 추가

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
    @Option(name: .customLong("input-xcassets"))
    var inputXCAssets: [String]
    
    @Option var assetType: AssetType = .imageSet
    
    @Option var keyTypeName: String
    
    @Option var moduleName: String?
    
    @Flag var excludeTypeDeclation: Bool = false
    
    @Option var keyDeclFile: String
    
    @Option var keyListFile: String?
    
    mutating func run() throws {
        let codes = try generateCodes()
        
        try writeKeyDeclFile(from: codes)
        
        try writeKeyListFileIfNeeded(from: codes)
    }
    
    private func generateCodes() throws -> AssetKeyGenerator.Result {
        let request = AssetKeyGenerator.Request(
            catalogURLs: inputXCAssets.map({ URL(fileURLWithExpandingTildeInPath: $0) }),
            assetType: assetType,
            keyTypeName: keyTypeName)
        
        return try AssetKeyGenerator().generate(for: request)
    }
    
    private func writeKeyDeclFile(from codes: AssetKeyGenerator.Result) throws {
        var stream = try TextFileOutputStream(forWritingTo: keyDeclFile)
        if !excludeTypeDeclation {
            print(codes.typeDeclaration, to: &stream)
        }
        print(codes.keyDeclarations, to: &stream)
    }
    
    private func writeKeyListFileIfNeeded(from codes: AssetKeyGenerator.Result) throws {
        guard let keyListFile = keyListFile else { return }
        var stream = try TextFileOutputStream(forWritingTo: keyListFile)
        print(codes.keyList, to: &stream)
    }
}

GenerateAssetKeys.main()
