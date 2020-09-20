import Foundation

class Tree<Element> {
    var element: Element
    weak var parent: Tree?
    var children: [Tree]
    
    init(_ element: Element) {
        self.element = element
        self.parent = nil
        self.children = []
    }
    
    var isRoot: Bool { parent == nil }
    var isLeaf: Bool { children.isEmpty }
    var hasChildren: Bool { !isLeaf }
    
    func addChild(_ tree: Tree) {
        children.append(tree)
        tree.parent = self
    }
}

extension Tree: Hashable {
    static func == (lhs: Tree<Element>, rhs: Tree<Element>) -> Bool {
        lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension Tree {
    func makePreOrderSequence() -> PreOrderTreeSequence<Element> {
        return PreOrderTreeSequence(tree: self)
    }
}

struct PreOrderTreeSequence<Element>: Sequence {
    let tree: Tree<Element>
    
    func makeIterator() -> Iterator {
        return Iterator(tree: tree)
    }
    
    struct Iterator: IteratorProtocol {
        private var stack: [Tree<Element>]
        
        init(tree: Tree<Element>) {
            self.stack = [tree]
        }
        
        mutating func next() -> Tree<Element>? {
            guard let last = stack.popLast() else { return nil }
            stack.append(contentsOf: last.children.reversed())
            return last
        }
    }
}
