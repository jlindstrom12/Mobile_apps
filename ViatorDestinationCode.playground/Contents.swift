import Foundation
import PlaygroundSupport
import CoreLocation
PlaygroundPage.current.needsIndefiniteExecution = true

guard let url = URL(string: "https://api.viator.com/partner/v1/taxonomy/destinations")
else{
    fatalError("Invalid URL")
}

var request = URLRequest(url: url)
request.httpMethod = "GET"

request.setValue("28ed06aa-9937-4a5e-9b9c-a992d05649a1", forHTTPHeaderField: "exp-api-key")
request.setValue("en-US", forHTTPHeaderField:"Accept-Language")

struct DestinationLocation: Decodable {
    let locations: [DestinationDetail]
    
    enum CodingKeys: String, CodingKey {
        case locations = "data"
    }
}

struct DestinationDetail: Decodable {
    let destinationId: Int
    let latitude: Float
    let longitude: Float
    
    enum CodingKeys: String, CodingKey{
        case destinationId
        case latitude
        case longitude
    }
                        
}



func findDestId(destIds: DestinationLocation) -> DestinationDetail
{
//    let lat = 40.44062479999999
//    let longitude = -79.9958864

    var shortestDistance: Double = Double(Int.max)
    var foundDest: DestinationDetail = DestinationDetail(destinationId: 0, latitude: 0.0, longitude: 0.0)

    let refCoordinates = (latitude: 40.44062479999999, longitude: 79.9958864)
    let refLocation = CLLocation(latitude: Double(refCoordinates.latitude), longitude: Double(refCoordinates.longitude))
    for dest in destIds.locations {
            var curCoordinates = (latitude: dest.latitude, longitude: dest.longitude)
            var curLocation = CLLocation(latitude: Double(curCoordinates.latitude), longitude: Double(refCoordinates.longitude))
            if (dest.destinationId == destIds.locations[0].destinationId)
            {
                shortestDistance = refLocation.distance(from: curLocation)
                foundDest = dest
            }
            else {
                if(shortestDistance > refLocation.distance(from: curLocation))
                {
                    foundDest = dest
                    shortestDistance = refLocation.distance(from: curLocation)

                }
            }
        }
    return foundDest
}
let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    guard let data = data else {
        print("Error: No data to decode")
        return
    }
    guard let result = try? JSONDecoder().decode(DestinationLocation.self, from: data) else {
        print("Error: Couldn't decode data into a result")
        return
    }
    let destId: DestinationDetail = findDestId(destIds: result)
    print("Places Count: \((result.locations).count)")
    print(destId)
    }

task.resume()

