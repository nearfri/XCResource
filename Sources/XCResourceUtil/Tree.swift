import Foundation

public class Tree<Element> {
    public let element: Element
    public private(set) weak var parent: Tree?
    public private(set) var children: [Tree] = []
    
    public init(_ element: Element, children: [Tree] = []) {
        self.element = element
        self.parent = nil
        
        children.forEach(addChild(_:))
    }
    
    public var isRoot: Bool { parent == nil }
    public var isLeaf: Bool { children.isEmpty }
    public var hasChildren: Bool { !isLeaf }
    
    public func addChild(_ child: Tree) {
        children.append(child)
        child.parent = self
    }
}

extension Tree: Hashable {
    public static func == (lhs: Tree<Element>, rhs: Tree<Element>) -> Bool {
        lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension Tree {
    public func makePreOrderSequence() -> PreOrderTreeSequence<Element> {
        return PreOrderTreeSequence(tree: self)
    }
}

public struct PreOrderTreeSequence<Element>: Sequence {
    public typealias Element = Tree<Element>
    
    let tree: Tree<Element>
    
    public func makeIterator() -> Iterator {
        return Iterator(tree: tree)
    }
    
    public struct Iterator: IteratorProtocol {
        private var stack: [Tree<Element>]
        
        init(tree: Tree<Element>) {
            self.stack = [tree]
        }
        
        public mutating func next() -> Tree<Element>? {
            guard let last = stack.popLast() else { return nil }
            stack.append(contentsOf: last.children.reversed())
            return last
        }
    }
}
