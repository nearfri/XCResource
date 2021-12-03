import Foundation

class StandardOutputSniffer {
    private let originalPipe: Pipe
    private let replacementPipe: Pipe
    private(set) var data: Data
    
    init() {
        originalPipe = Pipe()
        replacementPipe = Pipe()
        data = Data()
        
        // original write handle을 /dev/stdout으로 연결
        dup2(STDOUT_FILENO, originalPipe.fileHandleForWriting.fileDescriptor)
    }
    
    func start() {
        // stdout을 replacement write handle로 연결. 이제 stdout에 쓰는건 이 handle로 전달된다.
        dup2(replacementPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        
        replacementPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            self?.readAvailableData(from: handle)
        }
    }
    
    private func readAvailableData(from handle: FileHandle) {
        let newData = handle.availableData
        data += newData
        try? originalPipe.fileHandleForWriting.write(contentsOf: newData)
    }
    
    func stop() {
        synchronize()
        rollback()
    }
    
    private func synchronize() {
        try? replacementPipe.fileHandleForWriting.synchronize()
        try? replacementPipe.fileHandleForReading.synchronize()
    }
    
    private func rollback() {
        // stdout을 /dev/stdout으로 되돌린다.
        dup2(originalPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        
        replacementPipe.fileHandleForReading.readabilityHandler = nil
    }
    
    func resetData() {
        data.removeAll()
    }
    
    func stringFromData(encoding: String.Encoding = .utf8) -> String? {
        return String(data: data, encoding: encoding)
    }
}
