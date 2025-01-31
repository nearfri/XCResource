import Testing
import Foundation
import SampleData
@testable import AssetResourceGen

@Suite struct ContentTests {
    @Test func initWithURL_folder() throws {
        // Given
        let url = SampleData.assetURL("Settings")
        
        // When
        let content = try Content(url: url)
        
        // Then
        #expect(content.type == .group)
        #expect(content.providesNamespace == false)
        #expect(content.name == "Settings")
    }
    
    @Test func initWithURL_namespaceFolder() throws {
        // Given
        let url = SampleData.assetURL("Places/Dot")
        
        // When
        let content = try Content(url: url)
        
        // Then
        #expect(content.type == .group)
        #expect(content.providesNamespace == true)
        #expect(content.name == "Dot")
    }
    
    @Test func initWithURL_imageSet() throws {
        // Given
        let url = SampleData.assetURL("Settings/settingsRate.imageset")
        
        // When
        let content = try Content(url: url)
        
        // Then
        #expect(content.type == .asset(.imageSet))
        #expect(content.providesNamespace == false)
        #expect(content.name == "settingsRate")
    }
    
    @Test func initWithURL_colorSet() throws {
        // Given
        let url = SampleData.assetURL("Color/battleshipGrey8.colorset")
        
        // When
        let content = try Content(url: url)
        
        // Then
        #expect(content.type == .asset(.colorSet))
        #expect(content.providesNamespace == false)
        #expect(content.name == "battleshipGrey8")
    }
    
    @Test func namespace() throws {
        // Given
        let url = URL(filePath: "/root/tmp")
        
        // When
        let sut = try Content(url: url)
        
        // Then
        #expect(sut.namespace == "Tmp")
    }
    
    @Test func identifier() throws {
        // Given
        let url = SampleData.assetURL("Color/battleshipGrey8.colorset")
        
        // When
        let sut = try Content(url: url)
        
        // Then
        #expect(sut.identifier == "battleshipGrey8")
    }
}
