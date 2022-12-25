import Foundation

class DefaultFontImporter: FontImporter {
    private let fontFinder: FontFinder
    private let fontLoader: FontLoader
    
    init(fontFinder: FontFinder = .init(), fontLoader: FontLoader = .init()) {
        self.fontFinder = fontFinder
        self.fontLoader = fontLoader
    }
    
    func `import`(at url: URL) throws -> [Font] {
        let paths = try fontFinder.find(at: url)
        
        let fonts = try paths.flatMap({ try fontLoader.load(at: $0, relativeTo: url) })
        
        return fonts
    }
}
