import XCTest

private func SystemAssertEqual<T>(
    _ expression1: @autoclosure () throws -> T,
    _ expression2: @autoclosure () throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) where T: Equatable {
    XCTAssertEqual(try expression1(), try expression2(), message(), file: file, line: line)
}

public func XCTAssertEqual(
    _ string1: @autoclosure () throws -> String,
    _ string2: @autoclosure () throws -> String,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let str1: String
    let str2: String
    
    do {
        str1 = try string1()
        str2 = try string2()
    } catch {
        let msg = message()
        let msgSuffix = msg.isEmpty ? "" : ". \(msg)"
        XCTFail("threw error \"\(error)\"\(msgSuffix)", file: file, line: line)
        return
    }
    
    if str1 == str2 {
        return
    }
    
    var lines1 = str1.split(separator: "\n", omittingEmptySubsequences: false)
    var lines2 = str2.split(separator: "\n", omittingEmptySubsequences: false)
    
    if lines1.count == 1 && lines2.count == 1 {
        SystemAssertEqual(str1, str2, message(), file: file, line: line)
        return
    }
    
    lines1.append(contentsOf: Array(repeating: "", count: max(0, lines2.count - lines1.count)))
    lines2.append(contentsOf: Array(repeating: "", count: max(0, lines1.count - lines2.count)))
    
    for (index, (line1, line2)) in zip(lines1, lines2).enumerated() {
        if line1 != line2 {
            let msg = message()
            let msgSuffix = msg.isEmpty ? "" : ". \(msg)"
            XCTFail(
                """
                found different characters at line \(index + 1)\(msgSuffix)
                \t"\(line1)"
                \t"\(line2)"
                """,
                file: file,
                line: line
            )
            return
        }
    }
    
    preconditionFailure()
}
