import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

guard let url = URL(string: "https://places.googleapis.com/v1/places:searchNearby")
else{
    fatalError("Invalid URL")
}

var request = URLRequest(url: url)
request.httpMethod = "POST"

request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.setValue("AIzaSyCVdMC_MbfmFA5tz2LrhedfZoZOQL0hi0E", forHTTPHeaderField:"X-Goog-Api-Key")
request.setValue("places.id",forHTTPHeaderField:"X-Goog-FieldMask")

let json: [String:Any]=["includedTypes": ["restaurant"],
                        "maxResultCount": 10,
                        "rankPreference": "POPULARITY",
                        "locationRestriction": [
                          "circle": [
                            "center": [
                              "latitude": 40.44062479999999,
                              "longitude": -79.9958864],
                            "radius": 10000.0
                          ]
                        ]]

do {
    let jsonData = try JSONSerialization.data(withJSONObject: json, options:[])
    request.httpBody = jsonData
}

struct PlaceResult: Decodable{
    let places: [Place]
    enum CodingKeys: String, CodingKey{
        case places
    }
    
}
struct Place: Decodable{
    let placeId: String
    enum CodingKeys: String, CodingKey{
        case placeId = "id"
    }
}

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    guard let data = data else {
        print("Error: No data to decode")
        return
    }
    guard let result = try? JSONDecoder().decode(PlaceResult.self, from: data) else {
        print("Error: Couldn't decode data into a result")
        return
    }
    for p in result.places {
        print(p.placeId)
    }
    print("Places Count: \((result.places).count)")
    }

task.resume()



    



