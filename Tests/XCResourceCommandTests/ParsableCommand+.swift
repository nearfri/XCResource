import ArgumentParser

extension ParsableCommand {
    static func runAsRoot(arguments: [String]) throws {
        var command = try parseAsRoot(arguments)
        try command.run()
    }
}
