import Testing

public func expectEqual(
    _ string1: @autoclosure () throws -> String?,
    _ string2: @autoclosure () throws -> String?,
    _ comment: @autoclosure () -> Comment? = nil,
    sourceLocation: SourceLocation = #_sourceLocation
) {
    let str1: String
    let str2: String
    
    do {
        let optStr1 = try string1()
        let optStr2 = try string2()
        
        if let optStr1, let optStr2 {
            str1 = optStr1
            str2 = optStr2
        } else {
            let string1 = optStr1, string2 = optStr2
            #expect(string1 == string2, comment(), sourceLocation: sourceLocation)
            return
        }
    } catch {
        Issue.record(error, comment(), sourceLocation: sourceLocation)
        return
    }
    
    if str1 == str2 {
        return
    }
    
    let lines1 = str1.split(separator: "\n", omittingEmptySubsequences: false)
    let lines2 = str2.split(separator: "\n", omittingEmptySubsequences: false)
    
    if lines1.count <= 1 || lines2.count <= 1 {
        let string1 = str1, string2 = str2
        #expect(string1 == string2, comment(), sourceLocation: sourceLocation)
        return
    }
    
    func recordIssue(line1: some StringProtocol, line2: some StringProtocol, lineIndex: Int) {
        let commentSuffix = comment().map({ ". \($0)" }) ?? ""
        
        Issue.record(
                """
                found different characters at line \(lineIndex + 1)\(commentSuffix)
                lhs: "\(line1)"
                rhs: "\(line2)"
                
                \"\"\"\n\(str1)\n\"\"\" is not equal to \"\"\"\n\(str2)\n\"\"\"
                """,
                sourceLocation: sourceLocation
        )
    }
    
    for (index, (line1, line2)) in zip(lines1, lines2).enumerated() {
        if line1 != line2 {
            recordIssue(line1: line1, line2: line2, lineIndex: index)
            return
        }
    }
    
    let lineIndex = min(lines1.count, lines2.count)
    let line1 = lines1.dropFirst(lineIndex).first ?? ""
    let line2 = lines2.dropFirst(lineIndex).first ?? ""
    recordIssue(line1: line1, line2: line2, lineIndex: lineIndex)
}
