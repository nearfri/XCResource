import Foundation
import ArgumentParser
import AssetKeyGen

// argument 파싱
// v xcasset 폴더 뒤져서 모델화
// 필요한 타입들만 필터링해서 코드로 생성
//   테스트 파일 argument 있으면 테스트 파일에 모든 키 추출. 모듈 이름도 있으면 @test import 추가

// --input-xcassets
// --asset-type
// --key-type-name
// --excludes-type-declaration or includes-type-declaration
// --output-file
// --key-list-file
// --module-name
// generate-asset-keys -i Assets.xcassets -i Assets2.xcassets -o ImageKey.swift

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
    
    @Option var outputFile: String
    
    @Option var keyListFile: String
    
    mutating func run() throws {
        let codes = try generateCodes()
        
        print(codes)
    }
    
    private func generateCodes() throws -> AssetKeyGenerator.Result {
        let generatorRequest = AssetKeyGenerator.Request(
            catalogURLs: inputXCAssets.map({ URL(fileURLWithPath: $0) }),
            assetType: assetType,
            keyTypeName: keyTypeName)
        
        return try AssetKeyGenerator().generate(for: generatorRequest)
    }
}

GenerateAssetKeys.main()
