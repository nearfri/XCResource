import XCTest
import LocSwiftCore
@testable import LocStringFormGen

private class StubStringEnumerationImporter: StringEnumerationImporter {
    func `import`(at url: URL) throws -> Enumeration<String> {
        return Enumeration<String>(
            identifier: "StringKey",
            cases: [
                .init(comments: [.documentLine("취소")],
                      identifier: "cancel",
                      rawValue: "cancel"),
                .init(comments: [.line("영상은 최대 %@{duration}, %@{fileSize}까지만")],
                      identifier: "notDocumentComment",
                      rawValue: "notDocumentComment"),
                .init(comments: [.documentLine("영상은 최대 %@{duration}, %@{fileSize}까지만")],
                      identifier: "errorPopup_overMaximumSize",
                      rawValue: "errorPopup_overMaximumSize"),
                .init(comments: [.documentLine("%ld{fileCount}개의 파일을 로드하였습니다.")],
                      identifier: "fileLoadSuccess",
                      rawValue: "fileLoadSuccess"),
            ])
    }
}

private class StubFormatPlaceholderImporter: FormatPlaceholderImporter {
    var importParamStrings: [String] = []
    
    func `import`(from string: String) throws -> [FormatPlaceholder] {
        importParamStrings.append(string)
        
        switch string {
        case "영상은 최대 %@{duration}, %@{fileSize}까지만":
            return [
                FormatPlaceholder(valueType: String.self, labels: ["duration"]),
                FormatPlaceholder(valueType: String.self, labels: ["fileSize"]),
            ]
        case "%ld{fileCount}개의 파일을 로드하였습니다.":
            return [
                FormatPlaceholder(valueType: Int.self, labels: ["fileCount"]),
            ]
        default:
            return []
        }
    }
}

private class StubTypeDeclarationGenerator: TypeDeclarationGenerator {
    static let declarationString = "{ Type Declaration }"
    
    func generate(formTypeName: String, accessLevel: String?) -> String {
        return Self.declarationString
    }
}

private class StubMethodDeclationGenerator: MethodDeclationGenerator {
    static let declarationsString = "{ Method Declaration }"
    
    var generateParamItems: [FunctionItem] = []
    
    func generate(formTypeName: String,
                  accessLevel: String?,
                  keyTypeName: String,
                  items: [FunctionItem]) -> String {
        generateParamItems = items
        
        return Self.declarationsString
    }
}

final class StringFormGeneratorTests: XCTestCase {
    private var placeholderImporter: StubFormatPlaceholderImporter!
    private var methodDeclationGenerator: StubMethodDeclationGenerator!
    private var request: StringFormGenerator.Request!
    private var sut: StringFormGenerator!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        placeholderImporter = StubFormatPlaceholderImporter()
        methodDeclationGenerator = StubMethodDeclationGenerator()
        
        request = StringFormGenerator.Request(
            sourceCodeURL: URL(fileURLWithPath: "StringKey.swift"),
            formTypeName: "StringForm",
            accessLevel: nil)
        
        sut = StringFormGenerator(
            enumerationImporter: StubStringEnumerationImporter(),
            placeholderImporter: placeholderImporter,
            typeDeclationGenerator: StubTypeDeclarationGenerator(),
            methodDeclationGenerator: methodDeclationGenerator)
    }
    
    func test_generate_codes() throws {
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(result.typeDeclaration, StubTypeDeclarationGenerator.declarationString)
        
        XCTAssertEqual(result.methodDeclarations, StubMethodDeclationGenerator.declarationsString)
    }
    
    func test_generate_filterDocumentComment() throws {
        // When
        _ = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(placeholderImporter.importParamStrings, [
            "취소",
            "영상은 최대 %@{duration}, %@{fileSize}까지만",
            "%ld{fileCount}개의 파일을 로드하였습니다.",
        ])
    }
    
    func test_generate_filterFormatComment() throws {
        // When
        _ = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(methodDeclationGenerator.generateParamItems, [
            FunctionItem(
                enumCase: .init(
                    comments: [.documentLine("영상은 최대 %@{duration}, %@{fileSize}까지만")],
                    identifier: "errorPopup_overMaximumSize",
                    rawValue: "errorPopup_overMaximumSize"),
                parameters: [
                    .init(externalName: "", localName: "duration", type: String.self),
                    .init(externalName: "", localName: "fileSize", type: String.self),
                ]),
            FunctionItem(
                enumCase: .init(
                    comments: [.documentLine("%ld{fileCount}개의 파일을 로드하였습니다.")],
                    identifier: "fileLoadSuccess",
                    rawValue: "fileLoadSuccess"),
                parameters: [
                    .init(externalName: "", localName: "fileCount", type: Int.self),
                ]),
        ])
    }
}
