import Testing
import Foundation
@testable import XCResourceUtil

private actor DataStorage {
    private(set) var data = Data()
    
    func append(_ newData: Data) {
        data.append(newData)
    }
}

@Suite final class TextFileOutputStreamTests {
    private let fm: FileManager = .default
    
    private let testFileURL: URL
    
    init() throws {
        testFileURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    }
    
    deinit {
        try? fm.removeItem(at: testFileURL)
    }
    
    @Test func write() throws {
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
        let fileText = try String(contentsOf: testFileURL, encoding: .utf8)
        #expect(fileText == text)
    }
    
    @Test func initForWritingTo_overwrite() throws {
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
        let fileText = try String(contentsOf: testFileURL, encoding: .utf8)
        #expect(fileText == "hi")
    }
    
    @Test func initForWritingTo_append() throws {
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
        let fileText = try String(contentsOf: testFileURL, encoding: .utf8)
        #expect(fileText == text + "hi")
    }
    
    // 안해도 되는 테스트지만 재미삼아 해본다.
    // print(text, to: &TextFileOutputStream.standardOutput)가 print(text)와 동일한지 테스트하기 위해
    // stdout을 리다이렉트(?)해서 데이터를 캡쳐한다.
    @Test func standardOutput() async throws {
        // Given
        let stdPipe = Pipe()
        let stdWriteHandle = stdPipe.fileHandleForWriting
        let stdReadHandle = stdPipe.fileHandleForReading
        let actualStdPipe = Pipe()
        let actualStdWriteHandle = actualStdPipe.fileHandleForWriting
        
        // actualStdWHandle을 /dev/stdout로 연결
        #expect(dup2(STDOUT_FILENO, actualStdWriteHandle.fileDescriptor) != -1)
        
        fflush(stdout)
        
        // stdout을 stdWHandle로 연결. 이제 stdout에 쓰는건 stdWHandle로 전달된다.
        #expect(dup2(stdWriteHandle.fileDescriptor, STDOUT_FILENO) != -1)
        
        let dataStorage = DataStorage()
        
        stdReadHandle.readabilityHandler = { handle in
            let newData = handle.availableData
            Task {
                await dataStorage.append(newData)
            }
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
        
        try? stdWriteHandle.synchronize()
        try? stdReadHandle.synchronize()
        
        try await Task.sleep(for: .milliseconds(1))
        
        // stdout을 /dev/stdout으로 되돌린다.
        dup2(actualStdWriteHandle.fileDescriptor, STDOUT_FILENO)
        stdReadHandle.readabilityHandler = nil
        
        // Then
        let dataString = try #require(String(data: await dataStorage.data, encoding: .utf8))
        #expect(dataString == text)
    }
}
