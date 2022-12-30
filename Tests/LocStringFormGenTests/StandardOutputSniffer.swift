import Foundation

class StandardOutputSniffer {
    private let originalPipe: Pipe
    private let replacementPipe: Pipe
    private let dataLock: NSLocking
    private(set) var data: Data
    
    var dropsStandardOutput: Bool
    
    init(dropsStandardOutput: Bool = false) {
        self.originalPipe = Pipe()
        self.replacementPipe = Pipe()
        self.dataLock = NSLock()
        self.data = Data()
        self.dropsStandardOutput = dropsStandardOutput
        
        // original write handle을 /dev/stdout으로 연결
        dup2(STDOUT_FILENO, originalPipe.fileHandleForWriting.fileDescriptor)
    }
    
    func start() {
        fflush(stdout)
        
        // stdout을 replacement write handle로 연결. 이제 stdout에 쓰는건 이 handle로 전달된다.
        dup2(replacementPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        
        replacementPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            self?.readAvailableData(from: handle)
        }
    }
    
    private func readAvailableData(from handle: FileHandle) {
        dataLock.lock()
        defer { dataLock.unlock() }
        
        let newData = handle.availableData
        data += newData
        
        if !dropsStandardOutput {
            try? originalPipe.fileHandleForWriting.write(contentsOf: newData)
        }
    }
    
    func stop() {
        synchronize()
        rollback()
    }
    
    private func synchronize() {
        fflush(stdout)
        
        try? replacementPipe.fileHandleForWriting.synchronize()
        try? replacementPipe.fileHandleForReading.synchronize()
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.001))
    }
    
    private func rollback() {
        // stdout을 /dev/stdout으로 되돌린다.
        dup2(originalPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        
        replacementPipe.fileHandleForReading.readabilityHandler = nil
    }
    
    func resetData() {
        dataLock.lock()
        defer { dataLock.unlock() }
        
        data.removeAll()
    }
    
    func stringFromData(encoding: String.Encoding = .utf8) -> String? {
        dataLock.lock()
        defer { dataLock.unlock() }
        
        return String(data: data, encoding: encoding)
    }
}
