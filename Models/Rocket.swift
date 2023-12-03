
import Foundation

struct Rocket: Decodable, Identifiable {
    let id: String
    let name: String

//
//    struct Links: Decodable, Encodable { // skal være Encodable pga Launch
//        let patch: Patch
//    }
//    struct Patch: Decodable, Encodable { // skal være Encodable pga Links
//        let small: URL? // tager den small version for hurtigere load
    }
