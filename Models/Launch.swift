

import Foundation


//struct LaunchResult: Decodable {
//    let results: [Launch]
//}

struct Launch: Decodable, Encodable, Identifiable { // skal være encodable for at lave persistering i DetailsView
    let id: String // UUID().uuidString
    let name: String
    let links: Links
    let date_utc: String
    let rocket: String
//    let capsules: [String]?
    let launchpad: String
//    let crew: [String]?
//    let payloads: [String]?
    

    struct Links: Decodable, Encodable { // skal være Encodable pga Launch
        let patch: Patch
    }
    struct Patch: Decodable, Encodable { // skal være Encodable pga Links
        let small: URL? // tager den small version for hurtigere load
    }
    //-----------------------

//    let location:Location
    
//    var fullName: String {
//        return "\(name.title) \(name.first) \(name.last)"
//    }
    
//    struct Name: Decodable {
//        let name: String
//            let first: String
//            let last: String
//    }
    //-----------------------
//
//    struct Location: Decodable {
//        let coordinates: Coordinates
        
//        struct Coordinates: Decodable {
//            let latitude: String
//            let longitude: String
//        }
//    }
}
