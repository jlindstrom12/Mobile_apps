import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let url = "https://maps.googleapis.com/maps/api/geocode/json?address=Pittsburgh, +PA&key=AIzaSyCVdMC_MbfmFA5tz2LrhedfZoZOQL0hi0E"

struct LocationResult: Decodable {
//    let location: [String: String]
    let results: [LocationDetails]
    
  enum CodingKeys : String, CodingKey {
//    case location
      case results
  }
}

struct LocationDetails: Decodable {
    let geometry: Location
    
    enum CodingKeys: String, CodingKey {
        case geometry
    }
}

struct Location: Decodable {
    let location: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case location
    }
}

struct Coordinate: Decodable {
    let lat: Float
    let lng: Float
}

let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
    guard let data = data else {
      print("Error: No data to decode")
      return
    }
    print(data)
    guard let result = try? JSONDecoder().decode(LocationResult.self, from: data) else {
      print("Error: Couldn't decode data into a result")
      return
  }
    
    let longitude = result.results[0].geometry.location.lng
    let latitude = result.results[0].geometry.location.lat
    print("Longitude: \(longitude), Latitude: \(latitude)")
    
  
//  print("Total Count: \(result.totalCount)")
//  print("---------------------------")
//
//  print("Repositories:")
//  for repo in result.repos {
//    print("- \(repo.name)")
  }

task.resume()

