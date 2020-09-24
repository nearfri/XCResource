import Foundation

public class TextFileOutputStream {
    private let fileHandle: FileHandle
    
    private init(fileHandle: FileHandle) {
        self.fileHandle = fileHandle
    }
    
    public convenience init(forWritingTo url: URL, append shouldAppend: Bool = false) throws {
        let fm = FileManager.default
        
        if !fm.fileExists(atPath: url.path) || !shouldAppend {
            let directoryURL = url.deletingLastPathComponent()
            try fm.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            _ = fm.createFile(atPath: url.path, contents: nil)
        }
        
        self.init(fileHandle: try FileHandle(forWritingTo: url))
        
        if shouldAppend {
            try fileHandle.seekToEnd()
        }
    }
    
    public convenience init(forWritingTo path: String, append shouldAppend: Bool = false) throws {
        try self.init(forWritingTo: URL(fileURLWithPath: path))
    }
    
    public func close() throws {
        try fileHandle.close()
    }
}

extension TextFileOutputStream {
    private static let stdOut: TextFileOutputStream = .init(fileHandle: .standardOutput)
    public static var standardOutput: TextFileOutputStream {
        get { stdOut }
        set { /* ignore */ }
    }
    
    private static let stdErr: TextFileOutputStream = .init(fileHandle: .standardError)
    public static var standardError: TextFileOutputStream {
        get { stdErr }
        set { /* ignore */ }
    }
}

extension TextFileOutputStream: TextOutputStream {
    public func write(_ string: String) {
        do {
            let data = try string.toData()
            try fileHandle.write(contentsOf: data)
        } catch {
            preconditionFailure("\(error)")
        }
    }
}

private extension StringProtocol {
    func toData(using encoding: String.Encoding = .utf8) throws -> Data {
        guard let result = data(using: encoding) else {
            throw StringEncodingError(string: String(self), encoding: encoding)
        }
        return result
    }
}

public struct StringEncodingError: Error {
    public var string: String
    public var encoding: String.Encoding
}
