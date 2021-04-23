// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tideData = try? newJSONDecoder().decode(TideData.self, from: jsonData)

import Foundation

// MARK: - TideData
struct TideData: Codable {
    let soapenvBody: SoapenvBody
    let xmlAttributes: TideDataXMLAttributes

    enum CodingKeys: String, CodingKey {
        case soapenvBody = "soapenv:Body"
        case xmlAttributes = "_XMLAttributes"
    }
}

// MARK: - SoapenvBody
struct SoapenvBody: Codable {
    let searchResponse: SearchResponse
    let multiRef: [MultiRef]
}

// MARK: - MultiRef
struct MultiRef: Codable {
    let boundaryDepth: SearchReturn?
    let status: Latitude?
    let data: DataClass?
    let boundaryDate: SearchReturn?
    let size: Max?
    let boundarySpatial, boundaryValue: SearchReturn?
    let xmlAttributes: MultiRefXMLAttributes
    let metadata: MetadataClass?
    let message: Message?
    let longitude, latitude: Latitude?
    let name, value, max, min: Max?
    let spatialCoordinates: SpatialCoordinates?

    enum CodingKeys: String, CodingKey {
        case boundaryDepth, status, data, boundaryDate, size, boundarySpatial, boundaryValue
        case xmlAttributes = "_XMLAttributes"
        case metadata, message, longitude, latitude, name, value, max, min, spatialCoordinates
    }
}

// MARK: - SearchReturn
struct SearchReturn: Codable {
    let xmlAttributes: SearchReturnXMLAttributes

    enum CodingKeys: String, CodingKey {
        case xmlAttributes = "_XMLAttributes"
    }
}

// MARK: - SearchReturnXMLAttributes
struct SearchReturnXMLAttributes: Codable {
    let href: String
}

// MARK: - DataClass
struct DataClass: Codable {
    let xmlAttributes: DataXMLAttributes
    let data: [SearchReturn]

    enum CodingKeys: String, CodingKey {
        case xmlAttributes = "_XMLAttributes"
        case data
    }
}

// MARK: - DataXMLAttributes
struct DataXMLAttributes: Codable {
    let xsiType: PurpleXsiType
    let soapencArrayType: String

    enum CodingKeys: String, CodingKey {
        case xsiType = "xsi:type"
        case soapencArrayType = "soapenc:arrayType"
    }
}

enum PurpleXsiType: String, Codable {
    case soapencArray = "soapenc:Array"
}

// MARK: - Latitude
struct Latitude: Codable {
    let xmlAttributes: LatitudeXMLAttributes
    let swiftXMLParserTextKey: String?

    enum CodingKeys: String, CodingKey {
        case xmlAttributes = "_XMLAttributes"
        case swiftXMLParserTextKey = "SwiftXMLParserTextKey"
    }
}

// MARK: - LatitudeXMLAttributes
struct LatitudeXMLAttributes: Codable {
    let href: String?
    let xsiType: FluffyXsiType?

    enum CodingKeys: String, CodingKey {
        case href
        case xsiType = "xsi:type"
    }
}

enum FluffyXsiType: String, Codable {
    case xsdDouble = "xsd:double"
    case xsdInt = "xsd:int"
    case xsdString = "xsd:string"
}

// MARK: - Max
struct Max: Codable {
    let xmlAttributes: MaxXMLAttributes
    let swiftXMLParserTextKey: String

    enum CodingKeys: String, CodingKey {
        case xmlAttributes = "_XMLAttributes"
        case swiftXMLParserTextKey = "SwiftXMLParserTextKey"
    }
}

// MARK: - MaxXMLAttributes
struct MaxXMLAttributes: Codable {
    let xsiType: FluffyXsiType

    enum CodingKeys: String, CodingKey {
        case xsiType = "xsi:type"
    }
}

// MARK: - Message
struct Message: Codable {
    let xmlAttributes: MaxXMLAttributes

    enum CodingKeys: String, CodingKey {
        case xmlAttributes = "_XMLAttributes"
    }
}

// MARK: - MetadataClass
struct MetadataClass: Codable {
    let xmlAttributes: DataXMLAttributes
    let metadata: MetadataUnion

    enum CodingKeys: String, CodingKey {
        case xmlAttributes = "_XMLAttributes"
        case metadata
    }
}

enum MetadataUnion: Codable {
    case searchReturn(SearchReturn)
    case searchReturnArray([SearchReturn])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([SearchReturn].self) {
            self = .searchReturnArray(x)
            return
        }
        if let x = try? container.decode(SearchReturn.self) {
            self = .searchReturn(x)
            return
        }
        throw DecodingError.typeMismatch(MetadataUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MetadataUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .searchReturn(let x):
            try container.encode(x)
        case .searchReturnArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - SpatialCoordinates
struct SpatialCoordinates: Codable {
    let spatialCoordinates: SearchReturn
    let xmlAttributes: DataXMLAttributes

    enum CodingKeys: String, CodingKey {
        case spatialCoordinates
        case xmlAttributes = "_XMLAttributes"
    }
}

// MARK: - MultiRefXMLAttributes
struct MultiRefXMLAttributes: Codable {
    let id: String
    let xmlnsNs1: String?
    let soapenvEncodingStyle: String
    let soapencRoot: String
    let xmlnsSoapenc: String
    let xsiType: String
    let xmlnsNs2, xmlnsNs3, xmlnsNs4, xmlnsNs5: String?
    let xmlnsNs6, xmlnsNs7, xmlnsNs8, xmlnsNs9: String?
    let xmlnsNs10, xmlnsNs11, xmlnsNs12, xmlnsNs13: String?
    let xmlnsNs14, xmlnsNs15, xmlnsNs16, xmlnsNs17: String?
    let xmlnsNs18, xmlnsNs19, xmlnsNs20, xmlnsNs21: String?
    let xmlnsNs22, xmlnsNs23, xmlnsNs24, xmlnsNs25: String?
    let xmlnsNs26, xmlnsNs27, xmlnsNs28, xmlnsNs29: String?
    let xmlnsNs30, xmlnsNs31, xmlnsNs32, xmlnsNs33: String?

    enum CodingKeys: String, CodingKey {
        case id
        case xmlnsNs1 = "xmlns:ns1"
        case soapenvEncodingStyle = "soapenv:encodingStyle"
        case soapencRoot = "soapenc:root"
        case xmlnsSoapenc = "xmlns:soapenc"
        case xsiType = "xsi:type"
        case xmlnsNs2 = "xmlns:ns2"
        case xmlnsNs3 = "xmlns:ns3"
        case xmlnsNs4 = "xmlns:ns4"
        case xmlnsNs5 = "xmlns:ns5"
        case xmlnsNs6 = "xmlns:ns6"
        case xmlnsNs7 = "xmlns:ns7"
        case xmlnsNs8 = "xmlns:ns8"
        case xmlnsNs9 = "xmlns:ns9"
        case xmlnsNs10 = "xmlns:ns10"
        case xmlnsNs11 = "xmlns:ns11"
        case xmlnsNs12 = "xmlns:ns12"
        case xmlnsNs13 = "xmlns:ns13"
        case xmlnsNs14 = "xmlns:ns14"
        case xmlnsNs15 = "xmlns:ns15"
        case xmlnsNs16 = "xmlns:ns16"
        case xmlnsNs17 = "xmlns:ns17"
        case xmlnsNs18 = "xmlns:ns18"
        case xmlnsNs19 = "xmlns:ns19"
        case xmlnsNs20 = "xmlns:ns20"
        case xmlnsNs21 = "xmlns:ns21"
        case xmlnsNs22 = "xmlns:ns22"
        case xmlnsNs23 = "xmlns:ns23"
        case xmlnsNs24 = "xmlns:ns24"
        case xmlnsNs25 = "xmlns:ns25"
        case xmlnsNs26 = "xmlns:ns26"
        case xmlnsNs27 = "xmlns:ns27"
        case xmlnsNs28 = "xmlns:ns28"
        case xmlnsNs29 = "xmlns:ns29"
        case xmlnsNs30 = "xmlns:ns30"
        case xmlnsNs31 = "xmlns:ns31"
        case xmlnsNs32 = "xmlns:ns32"
        case xmlnsNs33 = "xmlns:ns33"
    }
}

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let searchReturn: SearchReturn
    let xmlAttributes: SearchResponseXMLAttributes

    enum CodingKeys: String, CodingKey {
        case searchReturn
        case xmlAttributes = "_XMLAttributes"
    }
}

// MARK: - SearchResponseXMLAttributes
struct SearchResponseXMLAttributes: Codable {
    let soapenvEncodingStyle: String

    enum CodingKeys: String, CodingKey {
        case soapenvEncodingStyle = "soapenv:encodingStyle"
    }
}

// MARK: - TideDataXMLAttributes
struct TideDataXMLAttributes: Codable {
    let xmlnsXsi, xmlnsXSD, xmlnsSoapenv: String

    enum CodingKeys: String, CodingKey {
        case xmlnsXsi = "xmlns:xsi"
        case xmlnsXSD = "xmlns:xsd"
        case xmlnsSoapenv = "xmlns:soapenv"
    }
}
