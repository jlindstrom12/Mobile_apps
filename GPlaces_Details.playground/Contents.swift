import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let places = ["ChIJwROTeR30NIgRcqMaE3fB2Co",
              "ChIJIT1oZvXzNIgRvLM0Pa2Ddq4",
              "ChIJE8r9NXbxNIgR2_MNy57jGM4",
              "ChIJldAGdt3zNIgRjGeERIxAoAE",
              "ChIJ09EneFjxNIgRypwsHoGxIE8",
              "ChIJ8YrAjVbxNIgRzyKm6e_bL8o",
              "ChIJsW0CpVbxNIgRtyWHiG9FaQU",
              "ChIJEfe6zHfxNIgRGR0MD0pIGHU",
              "ChIJE2GouT3uNIgRAbT_1kfLxoA",
              "ChIJWQh7rAzyNIgR2SmJQjW3nAs"]

guard let url = URL(string: "https://places.googleapis.com/v1/places/ChIJldAGdt3zNIgRjGeERIxAoAE")
else{
    fatalError("Invalid URL")
}
var request = URLRequest(url: url)
request.httpMethod = "GET"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.setValue("AIzaSyCVdMC_MbfmFA5tz2LrhedfZoZOQL0hi0E", forHTTPHeaderField:"X-Goog-Api-Key")
request.setValue("displayName,priceLevel,rating,photos,primaryTypeDisplayName,photos,websiteUri,regularOpeningHours",forHTTPHeaderField:"X-Goog-FieldMask")

struct DetailsResult: Decodable {
    let rating: Float
    let websiteUri: String
    let hours: Hour
    let priceLevel: String
    let name: DisplayName
    let type: PrimaryType
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case rating
        case websiteUri
        case hours = "regularOpeningHours"
        case priceLevel
        case name = "displayName"
        case type = "primaryTypeDisplayName"
        case photos
    }
}

struct Hour: Decodable {
    let weeklyHours: [String]
    
    enum CodingKeys: String, CodingKey {
        case weeklyHours = "weekdayDescriptions"
    }
}

struct DisplayName: Decodable {
    let nameText: String
    
    enum CodingKeys: String, CodingKey {
        case nameText = "text"
    }
}

struct PrimaryType: Decodable {
    let typeText: String
    
    enum CodingKeys: String, CodingKey {
        case typeText = "text"
    }
}

struct Photo: Decodable {
//    let name: String
//    
//    enum CodingKeys: String, CodingKey{
//        case name
//    }
    let details: [PhotoDetail]
    
    enum CodingKeys: String, CodingKey {
        case details = "authorAttributions"
    }
}

struct PhotoDetail: Decodable {
    let authorName: String
    let photoUri: String
    
    enum CodingKeys: String, CodingKey {
        case authorName = "displayName"
        case photoUri
    }
}

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    guard let data = data else {
        print("Error: No data to decode")
        return
    }
    guard let result = try? JSONDecoder().decode(DetailsResult.self, from: data) else {
        print("Error: Couldn't decode data into a result")
        return
    }
    
    print("Place Details")
    print("Restaurant Name: \(result.name.nameText)")
    print("Restaurant Type: \(result.type.typeText)")
    print("Rating: \(result.rating)")
    print("Hours: \((result.hours.weeklyHours))")
    print("Website: \(result.websiteUri)")
    print("Price Level: \(result.priceLevel)")
    for photo in result.photos
    {
        if(photo.details[0].authorName == result.name.nameText){
            print("Photo URL: \(photo.details[0].photoUri)")
        }
    }
}

task.resume()

//func createRequest(_ requestUrl: URL) -> URLRequest
//{
//    var request = URLRequest(url: requestUrl)
//    request.httpMethod = "GET"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue("AIzaSyCVdMC_MbfmFA5tz2LrhedfZoZOQL0hi0E", forHTTPHeaderField:"X-Goog-Api-Key")
//    request.setValue("displayName,priceLevel,rating,photos,primaryTypeDisplayName,types,photos,websiteUri,regularOpeningHours",forHTTPHeaderField:"X-Goog-FieldMask")
//    return request
//}
//
//func fetchData(request: URLRequest) async {
//    do {
//
//    }
//}
//for place in places{
//    guard let curUrl = URL(string: "https://places.googleapis.com/v1/\(place)")
//    else{
//        fatalError("Invalid URL")
//    }
//    var request = createRequest(curUrl)
//    
//}


