import XCTest
@testable import XCResourceUtil

final class TextFileOutputStreamTests: XCTestCase {
    let fm: FileManager = .default
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        try? fm.removeItem(at: testDirectoryURL)
        try fm.createDirectory(at: testDirectoryURL, withIntermediateDirectories: true)
    }
    
    override func tearDownWithError() throws {
        try? fm.removeItem(at: testDirectoryURL)
        
        try super.tearDownWithError()
    }
    
    var testDirectoryURL: URL {
        return fm.temporaryDirectory.appendingPathComponent("text-stream-test")
    }
    
    var testFileURL: URL {
        return testDirectoryURL.appendingPathComponent("output.txt")
    }
    
    func test_write() throws {
        // Given
        let text = """
        hello
        world
        !!
        """
        let lines = text.split(separator: "\n")
        
        var sut = try TextFileOutputStream(forWritingTo: testFileURL, append: false)
        
        // When
        var prefix = ""
        for line in lines {
            print(prefix, terminator: "", to: &sut)
            print(line, terminator: "", to: &sut)
            prefix = "\n"
        }
        try sut.close()
        
        // Then
        let fileText = try String(contentsOf: testFileURL)
        XCTAssertEqual(fileText, text)
    }
    
    func test_initForWritingTo_overwrite() throws {
        // Given
        try """
        hello world
        hello text
        hello iPhone
        hello iPad
        hello Mac
        """.write(to: testFileURL, atomically: true, encoding: .utf8)
        
        // When
        var sut = try TextFileOutputStream(forWritingTo: testFileURL, append: false)
        print("hi", terminator: "", to: &sut)
        try sut.close()
        
        // Then
        let fileText = try String(contentsOf: testFileURL)
        XCTAssertEqual(fileText, "hi")
    }
    
    func test_initForWritingTo_append() throws {
        // Given
        let text = """
        hello
        world
        !!
        """
        
        try text.write(to: testFileURL, atomically: true, encoding: .utf8)
        
        // When
        var sut = try TextFileOutputStream(forWritingTo: testFileURL, append: true)
        print("hi", terminator: "", to: &sut)
        try sut.close()
        
        // Then
        let fileText = try String(contentsOf: testFileURL)
        XCTAssertEqual(fileText, text + "hi")
    }
    
    // 안해도 되는 테스트지만 재미삼아 해본다.
    // print(text, to: &TextFileOutputStream.standardOutput)가 print(text)와 동일한지 테스트하기 위해
    // stdout을 리다이렉트(?)해서 데이터를 캡쳐한다.
    func test_standardOutput() throws {
        // Given
        let stdPipe = Pipe()
        let stdWriteHandle = stdPipe.fileHandleForWriting
        let stdReadHandle = stdPipe.fileHandleForReading
        let actualStdPipe = Pipe()
        let actualStdWriteHandle = actualStdPipe.fileHandleForWriting
        
        // actualStdWHandle을 /dev/stdout로 연결
        XCTAssertNotEqual(dup2(STDOUT_FILENO, actualStdWriteHandle.fileDescriptor), -1)
        
        // stdout을 stdWHandle로 연결. 이제 stdout에 쓰는건 stdWHandle로 전달된다.
        XCTAssertNotEqual(dup2(stdWriteHandle.fileDescriptor, STDOUT_FILENO), -1)
        
        var data = Data()
        stdReadHandle.readabilityHandler = { handle in
            let newData = handle.availableData
            data += newData
            // 콘솔에도 출력하고 싶다면 아래 주석 제거
            // actualStdPipe.fileHandleForWriting.write(newData)
        }
        
        let text = """
        hello
        world
        !!
        """
        
        // When
        print(text, terminator: "", to: &TextFileOutputStream.standardOutput)
        fflush(stdout)
        stdReadHandle.waitForDataInBackgroundAndNotify(forModes: [.default])
        
        // Then
        let dataString = try XCTUnwrap(String(data: data, encoding: .utf8))
        XCTAssertEqual(dataString, text)
    }
}
