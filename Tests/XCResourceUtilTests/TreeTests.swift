import Testing
@testable import XCResourceUtil

@Suite struct TreeTests {
    @Test func addChild() throws {
        // Given
        let parent = Tree(0)
        let child = Tree(1)
        
        // When
        parent.addChild(child)
        
        // Then
        #expect(child.parent == parent)
        #expect(parent.children.first == child)
    }
    
    @Test func filter_matchGrandChild() throws {
        let tree: Tree<String> = Tree("root", children: [
            Tree("child1", children: [
                Tree("grandChild1A"), Tree("grandChild1B")
            ]),
            Tree("child2", children: [
                Tree("grandChild2A"), Tree("grandChild2B")
            ]),
        ])
        
        let filtered = try #require(tree.filter({ name in
            return name == "grandChild2A"
        }))
        
        #expect(filtered.element == "root")
        
        #expect(filtered.children.count == 1)
        let child = try #require(filtered.children.first)
        #expect(child.element == "child2")
        
        #expect(child.children.count == 1)
        let grandChild = try #require(child.children.first)
        #expect(grandChild.element == "grandChild2A")
    }
    
    @Test func filter_matchChild() throws {
        let tree: Tree<String> = Tree("root", children: [
            Tree("child1", children: [
                Tree("grandChild1A"), Tree("grandChild1B")
            ]),
            Tree("child2", children: [
                Tree("grandChild2A"), Tree("grandChild2B")
            ]),
        ])
        
        let filtered = try #require(tree.filter({ name in
            return name == "child2"
        }))
        
        #expect(filtered.element == "root")
        
        #expect(filtered.children.count == 1)
        let child = try #require(filtered.children.first)
        #expect(child.element == "child2")
        
        #expect(child.children.count == 2)
        let grandChildA = try #require(child.children.first)
        #expect(grandChildA.element == "grandChild2A")
        let grandChildB = try #require(child.children.dropFirst().first)
        #expect(grandChildB.element == "grandChild2B")
    }
    
    @Test func filter_noMatch() throws {
        let tree: Tree<String> = Tree("root", children: [
            Tree("child1", children: [
                Tree("grandChild1A"), Tree("grandChild1B")
            ]),
            Tree("child2", children: [
                Tree("grandChild2A"), Tree("grandChild2B")
            ]),
        ])
        
        let filtered = tree.filter { name in
            return name == "notExist"
        }
        
        #expect(filtered == nil)
    }
    
    @Test func preOrderSequence() {
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
        #expect(allTrees == [
            a, aa, aaa, aab, ab, aba, abaa, ac, aca, acb, acc
        ])
    }
}
