import Foundation
import OrderedCollections

public typealias PlistDictionary = OrderedDictionary<String, Plist>

public enum Plist: Equatable {
    case dictionary(PlistDictionary)
    case array([Plist])
    case string(String)
    case number(NSNumber)
    case bool(Bool)
    case date(Date)
    case data(Data)
    
    public static func int(_ number: Int) -> Plist {
        return .number(NSNumber(value: number))
    }
    
    public static func double(_ number: Double) -> Plist {
        return .number(NSNumber(value: number))
    }
    
    public subscript(key: String) -> Plist? {
        if case .dictionary(let dict) = self {
            return dict[key]
        }
        return nil
    }
    
    public var dictionaryValue: PlistDictionary? {
        if case .dictionary(let dictionary) = self {
            return dictionary
        }
        return nil
    }
    
    public var arrayValue: [Plist]? {
        if case .array(let array) = self {
            return array
        }
        return nil
    }
    
    public var stringValue: String? {
        if case .string(let str) = self {
            return str
        }
        return nil
    }
    
    public var numberValue: NSNumber? {
        if case .number(let num) = self {
            return num
        }
        return nil
    }
    
    public var doubleValue: Double? {
        return numberValue?.doubleValue
    }
    
    public var intValue: Int? {
        return numberValue?.intValue
    }
    
    public var boolValue: Bool? {
        if case .bool(let boolean) = self {
            return boolean
        }
        return nil
    }
    
    public var dateValue: Date? {
        if case .date(let date) = self {
            return date
        }
        return nil
    }
    
    public var dataValue: Data? {
        if case .data(let data) = self {
            return data
        }
        return nil
    }
    
    public var value: Any {
        switch self {
        case .dictionary(let dictionary):
            return dictionary
        case .array(let array):
            return array
        case .string(let string):
            return string
        case .number(let number):
            return number
        case .bool(let bool):
            return bool
        case .date(let date):
            return date
        case .data(let data):
            return data
        }
    }
}

extension PlistDictionary {
    public func value<T>(forKey key: String, type: T.Type) throws -> T {
        guard let plist = self[key] else {
            throw Plist.KeyValueError.keyNotFound(key, in: self)
        }
        
        guard let value = plist.value as? T else {
            let actualType = Swift.type(of: plist.value)
            throw Plist.KeyValueError.typeMismatch(expected: type, actual: actualType)
        }
        
        return value
    }
}

extension Plist {
    public enum KeyValueError: Error {
        case keyNotFound(String, in: PlistDictionary)
        case typeMismatch(expected: Any.Type, actual: Any.Type)
    }
}

extension Plist: CustomStringConvertible {
    public var description: String {
        return xmlElementString
    }
}

extension Plist {
    public init(contentsOf url: URL, options mask: XMLNode.Options = []) throws {
        let xmlDocument = try XMLDocument(contentsOf: url, options: mask)
        
        try self.init(xmlDocument: xmlDocument)
    }
    
    public init(xmlDocumentString: String, options mask: XMLNode.Options = []) throws {
        let xmlDocument = try XMLDocument(xmlString: xmlDocumentString, options: mask)
        
        try self.init(xmlDocument: xmlDocument)
    }
    
    public init(xmlDocument: XMLDocument) throws {
        guard let root = xmlDocument.rootElement(), root.localName == "plist",
              root.childCount == 1, let child = root.child(at: 0) as? XMLElement
        else { throw DecodingError.invalidRootElement }
        
        self = try Plist(xmlElement: child)
    }
    
    public init(xmlElementString: String) throws {
        let xmlElement = try XMLElement(xmlString: xmlElementString)
        
        try self.init(xmlElement: xmlElement)
    }
    
    public init(xmlElement: XMLElement) throws {
        let xPath = xmlElement.xPath
        
        guard let localName = xmlElement.localName else {
            throw DecodingError.noElementName(xPath: xPath)
        }
        
        switch localName {
        case Tag.dict:
            let children = xmlElement.children as? [XMLElement]
            self = .dictionary(try Self.dictionary(from: children, xPath: xPath))
        case Tag.array:
            let children = xmlElement.children as? [XMLElement]
            self = .array(try Self.array(from: children, xPath: xPath))
        case Tag.string:
            self = .string(try Self.string(from: xmlElement.stringValue, xPath: xPath))
        case Tag.integer:
            self = .number(try Self.integer(from: xmlElement.stringValue, xPath: xPath))
        case Tag.real:
            self = .number(try Self.double(from: xmlElement.stringValue, xPath: xPath))
        case Tag.true:
            self = .bool(true)
        case Tag.false:
            self = .bool(false)
        case Tag.date:
            self = .date(try Self.date(from: xmlElement.stringValue, xPath: xPath))
        case Tag.data:
            self = .data(try Self.data(from: xmlElement.stringValue, xPath: xPath))
        default:
            throw DecodingError.invalidElementName(localName, xPath: xPath)
        }
    }
    
    private static let dateFormatter: ISO8601DateFormatter = .init()
    
    private static func dictionary(
        from elements: [XMLElement]?,
        xPath: String?
    ) throws -> PlistDictionary {
        guard let elements else { return [:] }
        
        guard elements.count.isMultiple(of: 2) else {
            throw DecodingError.invalidDictionary(xPath: xPath)
        }
        
        let indices = stride(from: 0, to: elements.count, by: 2)
        
        return try indices.reduce(into: [:]) { partialResult, index in
            let keyElement = elements[index]
            let valueElement = elements[index + 1]
            
            guard keyElement.localName == Tag.key, let key = keyElement.stringValue else {
                throw DecodingError.invalidDictionary(xPath: keyElement.xPath)
            }
            
            partialResult[key] = try Plist(xmlElement: valueElement)
        }
    }
    
    private static func array(from elements: [XMLElement]?, xPath: String?) throws -> [Plist] {
        guard let elements else { return [] }
        
        return try elements.map({ try Plist(xmlElement: $0) })
    }
    
    private static func string(from stringValue: String?, xPath: String?) throws -> String {
        guard let string = stringValue else {
            throw DecodingError.invalidElementValue(nil, xPath: xPath)
        }
        return string
    }
    
    private static func integer(from stringValue: String?, xPath: String?) throws -> NSNumber {
        guard let string = stringValue, let number = Int(string) else {
            throw DecodingError.invalidElementValue(stringValue, xPath: xPath)
        }
        return NSNumber(value: number)
    }
    
    private static func double(from stringValue: String?, xPath: String?) throws -> NSNumber {
        guard let string = stringValue, let number = Double(string) else {
            throw DecodingError.invalidElementValue(stringValue, xPath: xPath)
        }
        return NSNumber(value: number)
    }
    
    private static func date(from stringValue: String?, xPath: String?) throws -> Date {
        guard let string = stringValue, let date = dateFormatter.date(from: string) else {
            throw DecodingError.invalidElementValue(stringValue, xPath: xPath)
        }
        return date
    }
    
    private static func data(from stringValue: String?, xPath: String?) throws -> Data {
        guard let string = stringValue, let data = Data(base64Encoded: string) else {
            throw DecodingError.invalidElementValue(stringValue, xPath: xPath)
        }
        return data
    }
}

extension Plist {
    fileprivate enum Tag {
        static let plist: String = "plist"
        static let dict: String = "dict"
        static let array: String = "array"
        static let string: String = "string"
        static let integer: String = "integer"
        static let real: String = "real"
        static let `true`: String = "true"
        static let `false`: String = "false"
        static let date: String = "date"
        static let data: String = "data"
        static let key: String = "key"
    }
    
    public enum DecodingError: Error {
        case invalidRootElement
        case noElementName(xPath: String?)
        case invalidDictionary(xPath: String?)
        case invalidElementName(String, xPath: String?)
        case invalidElementValue(String?, xPath: String?)
    }
}

extension Plist {
    public var xmlDocument: XMLDocument {
        let root = XMLElement(name: Tag.plist)
        root.addChild(xmlElement)
        root.setAttributesWith(["version": "1.0"])
        
        let result = XMLDocument(rootElement: root)
        result.version = "1.0"
        result.characterEncoding = "UTF-8"
        
        result.dtd = XMLDTD()
        result.dtd?.name = "plist"
        result.dtd?.publicID = "-//Apple//DTD PLIST 1.0//EN"
        result.dtd?.systemID = "http://www.apple.com/DTDs/PropertyList-1.0.dtd"
        
        return result
    }
    
    public var xmlElement: XMLElement {
        switch self {
        case .dictionary(let dictionary):
            let result = XMLElement(name: Tag.dict)
            dictionary.forEach { key, plist in
                result.addChild(XMLElement(name: Tag.key, stringValue: key))
                result.addChild(plist.xmlElement)
            }
            return result
        case .array(let array):
            let result = XMLElement(name: Tag.array)
            array.forEach {
                result.addChild($0.xmlElement)
            }
            return result
        case .string(let string):
            return XMLElement(name: Tag.string, stringValue: string)
        case .number(let number):
            let stringValue = number.stringValue
            let name = Int(stringValue) != nil ? Tag.integer: Tag.real
            return XMLElement(name: name, stringValue: stringValue)
        case .bool(let bool):
            return XMLElement(name: bool ? Tag.true : Tag.false)
        case .date(let date):
            return XMLElement(name: Tag.date, stringValue: Self.dateFormatter.string(from: date))
        case .data(let data):
            return XMLElement(name: Tag.data, stringValue: data.base64EncodedString())
        }
    }
}

extension Plist {
    public var xmlDocumentString: String {
        return XMLPlistEncoder.documentString(from: self)
    }
    
    public var xmlElementString: String {
        return XMLPlistEncoder.elementString(from: self)
    }
}

private struct XMLPlistEncoder {
    private typealias Tag = Plist.Tag
    
    private var text: String = ""
    private var indent: String = ""
    
    static func documentString(from plist: Plist) -> String {
        var encoder = XMLPlistEncoder()
        
        encoder.writeDeclaration()
        encoder.writeDTD()
        encoder.writePlistStartTag()
        encoder.write(plist)
        encoder.writePlistEndTag()
        
        return encoder.text.trimmingCharacters(in: .newlines)
    }
    
    static func elementString(from plist: Plist) -> String {
        var encoder = XMLPlistEncoder()
        
        encoder.write(plist)
        
        return encoder.text.trimmingCharacters(in: .newlines)
    }
    
    private mutating func writeDeclaration() {
        text += "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    }
    
    private mutating func writeDTD() {
        text += "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" "
        text += "\"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n"
    }
    
    private mutating func writePlistStartTag() {
        text += "<\(Tag.plist) version=\"1.0\">\n"
    }
    
    private mutating func writePlistEndTag() {
        text += "</\(Tag.plist)>\n"
    }
    
    private mutating func write(_ plist: Plist) {
        switch plist {
        case .dictionary(let dictionary):
            write(dictionary)
        case .array(let array):
            write(array)
        case .string, .number, .bool, .date, .data:
            text += plist.xmlElement.xmlString(options: [.nodeCompactEmptyElement])
            text += "\n"
        }
    }
    
    private mutating func write(_ dictionary: PlistDictionary) {
        if dictionary.isEmpty {
            text += "<\(Tag.dict)/>\n"
            return
        }
        
        text += "<\(Tag.dict)>\n"
        indent += "\t"
        
        for (key, plist) in dictionary {
            text += "\(indent)<\(Tag.key)>\(key)</\(Tag.key)>\n\(indent)"
            write(plist)
        }
        
        indent.removeLast()
        text += "\(indent)</\(Tag.dict)>\n"
    }
    
    private mutating func write(_ array: [Plist]) {
        if array.isEmpty {
            text += "<\(Tag.array)/>\n"
            return
        }
        
        text += "<\(Tag.array)>\n"
        indent += "\t"
        
        for plist in array {
            text += indent
            write(plist)
        }
        
        indent.removeLast()
        text += "\(indent)</\(Tag.array)>\n"
    }
}
