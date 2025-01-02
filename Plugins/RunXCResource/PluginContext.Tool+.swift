import Foundation
import PackagePlugin

extension PluginContext.Tool {
    func execute(arguments: [String]) async throws {
        let process = Process()
        process.executableURL = url
        process.arguments = arguments
        
        try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        try process.run()
                        process.waitUntilExit()
                        try process.validateTermination()
                        
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        } onCancel: {
            process.terminate()
        }
    }
}

private extension Process {
    func validateTermination() throws {
        guard let toolName = executableURL?.lastPathComponent else { preconditionFailure() }
        
        guard terminationReason == .exit, terminationStatus == 0 else {
            throw PluginError.toolRunFailed(
                name: toolName,
                reason: terminationReason,
                status: terminationStatus)
        }
    }
}

enum PluginError: LocalizedError, CustomStringConvertible {
    case toolRunFailed(name: String, reason: Process.TerminationReason, status: Int32)
    
    var description: String {
        switch self {
        case let .toolRunFailed(name, reason, status):
            return """
                '\(name)' invocation failed with exit code '\(status)' \
                and reason '\(reason.rawValue)'.
                """
        }
    }
    
    var errorDescription: String? {
        return description
    }
}
