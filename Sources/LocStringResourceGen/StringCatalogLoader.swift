import Foundation

class StringCatalogLoader: CatalogLocalizationItemLoader {
    func load(source: String) throws -> [LocalizationItem] {
        let sourceData = Data(source.utf8)
        let catalogDTO = try JSONDecoder().decode(StringCatalogDTO.self, from: sourceData)
        return try StringCatalogDTOMapper().localizationItems(from: catalogDTO)
    }
}
