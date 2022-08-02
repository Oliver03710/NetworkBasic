//
//  BeerData.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/01.
//

import Foundation

//// MARK: - WelcomeElement
//struct BeerRecommendation: Codable {
//    let id: Int
//    let name, tagline, firstBrewed, welcomeDescription: String
//    let imageURL: String
//    let abv: Double
//    let ibu, targetFg, targetOg, ebc: Int
//    let srm: Int
//    let ph: Double
//    let attenuationLevel: Int
//    let volume, boilVolume: BoilVolume
//    let method: Method
//    let ingredients: Ingredients
//    let foodPairing: [String]
//    let brewersTips, contributedBy: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, tagline
//        case firstBrewed = "first_brewed"
//        case welcomeDescription = "description"
//        case imageURL = "image_url"
//        case abv, ibu
//        case targetFg = "target_fg"
//        case targetOg = "target_og"
//        case ebc, srm, ph
//        case attenuationLevel = "attenuation_level"
//        case volume
//        case boilVolume = "boil_volume"
//        case method, ingredients
//        case foodPairing = "food_pairing"
//        case brewersTips = "brewers_tips"
//        case contributedBy = "contributed_by"
//    }
//}
//
//// MARK: - BoilVolume
//struct BoilVolume: Codable {
//    let value: Double
//    let unit: String
//}
//
//// MARK: - Ingredients
//struct Ingredients: Codable {
//    let malt: [Malt]
//    let hops: [Hop]
//    let yeast: String
//}
//
//// MARK: - Hop
//struct Hop: Codable {
//    let name: String
//    let amount: BoilVolume
//    let add, attribute: String
//}
//
//// MARK: - Malt
//struct Malt: Codable {
//    let name: String
//    let amount: BoilVolume
//}
//
//// MARK: - Method
//struct Method: Codable {
//    let mashTemp: [MashTemp]
//    let fermentation: Fermentation
//    let twist: JSONNull?
//
//    enum CodingKeys: String, CodingKey {
//        case mashTemp = "mash_temp"
//        case fermentation, twist
//    }
//}
//
//// MARK: - Fermentation
//struct Fermentation: Codable {
//    let temp: BoilVolume
//}
//
//// MARK: - MashTemp
//struct MashTemp: Codable {
//    let temp: BoilVolume
//    let duration: JSONNull?
//}
//
//typealias Welcome = [WelcomeElement]
//
//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
