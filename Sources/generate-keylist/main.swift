import Foundation
import ArgumentParser
import StaticKeyListGen
import ResourceKeyUtil

let headerComment = """
// Generated from \(ProcessInfo.processInfo.processName).
// Do Not Edit Directly!
"""

struct GenerateKeyList: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "generate-keylist",
        abstract: "키 리스트 파일 생성.",
        discussion: """
            키 파일에서 키를 추출해서 키 리스트 파일을 생성한다.
            추출한 키 리스트 파일은 유닛 테스트에 사용할 수 있다.
            """)
    
    // MARK: - Arguments
    
    @Option var typeName: String
    
    @Option var listName: String = "allGeneratedKeys"
    
    @Option(help: "<output-file>에 '@testable import <module-name>' 추가")
    var moduleName: String?
    
    @Option var inputFile: String
    
    @Option var outputFile: String
    
    // MARK: - Run
    
    mutating func run() throws {
        let code = try generateCode()
        
        try writeKeyListFile(fromCode: code)
    }
    
    private func generateCode() throws -> String {
        let request = StaticKeyListGenerator.CodeRequest(
            sourceCodeURL: URL(fileURLWithExpandingTildeInPath: inputFile),
            typeName: typeName,
            listName: listName)
        
        return try StaticKeyListGenerator().generate(for: request)
    }
    
    private func writeKeyListFile(fromCode code: String) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        var stream = try TextFileOutputStream(forWritingTo: tempFileURL)
        
        print(headerComment, terminator: "\n\n", to: &stream)
        
        if let moduleName = moduleName {
            print("@testable import \(moduleName)", terminator: "\n\n", to: &stream)
        }
        
        print(code, to: &stream)
        
        try stream.close()
        try FileManager.default.compareAndReplaceItem(at: outputFile, withItemAt: tempFileURL)
    }
}

GenerateKeyList.main()
