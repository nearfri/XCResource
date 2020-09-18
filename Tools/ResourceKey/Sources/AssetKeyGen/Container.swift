import Foundation

enum ContainerType {
    case folder, imageSet, colorSet, symbolSet
}

struct Container {
    var url: URL
    var type: ContainerType
    var providesNamespace: Bool
    
    var name: String {
        if type == .folder {
            return url.lastPathComponent
        } else {
            return url.deletingPathExtension().lastPathComponent
        }
    }
}

extension Container {
    init(contentsOf url: URL) throws {
        self.url = url
        
        let data = try Data(contentsOf: url.appendingPathComponent("Contents.json"))
        let content = try JSONDecoder().decode(ContentRecord.self, from: data)
        self.type = content.type?.toContainerType() ?? .folder
        self.providesNamespace = content.properties?.providesNamespace ?? false
    }
}
