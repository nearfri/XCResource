import Foundation
import ArgumentParser
import FileKeyGen
import XCResourceUtil

private let headerComment = """
// This file was generated by xcresource
// Do Not Edit Directly!
"""

struct FilesToSwift: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "files2swift",
        abstract: "파일 로딩용 키 파일 생성",
        discussion: """
            디렉토리에서 패턴에 매칭되는 파일의 이름으로 키 파일을 생성한다.
            """)
    
    // MARK: - Default values
    
    enum Default {
        static let bundle: String = "Bundle.main"
        static let preservesRelativePath: Bool = true
        static let excludesTypeDeclaration: Bool = false
    }
    
    // MARK: - Arguments
    
    @Option var resourcesPath: String
    
    @Option var filePattern: String
    
    @Option var swiftPath: String
    
    @Option var keyTypeName: String
    
    @Flag(name: .customLong("preserve-relative-path"), inversion: .prefixedNo)
    var preservesRelativePath: Bool = Default.preservesRelativePath
    
    @Option var relativePathPrefix: String?
    
    @Option var bundle: String = Default.bundle
    
    @Option(help: ArgumentHelp(valueName: AccessLevel.joinedAllValuesString))
    var accessLevel: AccessLevel?
    
    @Flag(name: .customLong("exclude-type-declaration"))
    var excludesTypeDeclaration: Bool = Default.excludesTypeDeclaration
    
    // MARK: - Run
    
    mutating func run() throws {
        let codes = try generateCodes()
        
        try writeCodes(codes)
    }
    
    private func generateCodes() throws -> FileKeyGenerator.Result {
        let request = FileKeyGenerator.Request(
            resourcesURL: URL(fileURLWithExpandingTildeInPath: resourcesPath),
            filePattern: filePattern,
            keyTypeName: keyTypeName,
            preservesRelativePath: preservesRelativePath,
            relativePathPrefix: relativePathPrefix,
            bundle: bundle,
            accessLevel: accessLevel?.rawValue)
        
        return try FileKeyGenerator().generate(for: request)
    }
    
    private func writeCodes(_ codes: FileKeyGenerator.Result) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        var stream = try TextFileOutputStream(forWritingTo: tempFileURL)
        
        print(headerComment, terminator: "\n\n", to: &stream)
        
        print("import Foundation", terminator: "\n\n", to: &stream)
        
        if !excludesTypeDeclaration {
            print(codes.typeDeclaration, terminator: "\n\n", to: &stream)
        }
        
        print(codes.keyDeclarations, to: &stream)
        
        try stream.close()
        try FileManager.default.compareAndReplaceItem(at: swiftPath, withItemAt: tempFileURL)
    }
}
