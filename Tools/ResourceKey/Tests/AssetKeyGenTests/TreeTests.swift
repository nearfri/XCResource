import XCTest
@testable import AssetKeyGen

final class TreeTests: XCTestCase {
    func test_addChild() throws {
        // Given
        let parent = Tree(0)
        let child = Tree(1)
        
        // When
        parent.addChild(child)
        
        // Then
        XCTAssertEqual(child.parent, parent)
        XCTAssertEqual(parent.children.first, child)
    }
    
    func test_preOrderSequence() {
        // Given
        let a = Tree("a")
        
        let (aa, ab, ac) = (Tree("aa"), Tree("ab"), Tree("ac"))
        a.addChild(aa)
        a.addChild(ab)
        a.addChild(ac)
        
        let (aaa, aab) = (Tree("aaa"), Tree("aab"))
        aa.addChild(aaa)
        aa.addChild(aab)
        
        let aba = Tree("aba")
        ab.addChild(aba)
        
        let abaa = Tree("abaa")
        aba.addChild(abaa)
        
        let (aca, acb, acc) = (Tree("aca"), Tree("acb"), Tree("acc"))
        ac.addChild(aca)
        ac.addChild(acb)
        ac.addChild(acc)
        
        // When
        let allTrees: [Tree<String>] = a.makePreOrderSequence().reduce(into: [], { $0.append($1) })
        
        // Then
        XCTAssertEqual(allTrees, [
            a, aa, aaa, aab, ab, aba, abaa, ac, aca, acb, acc
        ])
    }
}
