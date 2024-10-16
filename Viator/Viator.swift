//
//  Viator.swift
//  Viator
//
//  Created by Juan Pablo Urista on 10/10/24.
//

import Foundation
import Alamofire

struct ActivityDuration: Codable {
  let durationInMinutes: Int
  
  enum CodingKeys: String, CodingKey {
    case durationInMinutes = "fixedDurationInMinutes"
  }
}

struct Reviews: Codable {
  let totalReviews: Int
  let averageRating: Float
  
  enum CodingKeys: String, CodingKey {
    case totalReviews
    case averageRating = "combinedAverageRating"
  }
}

struct Activity: Codable, Identifiable {
  let id: String
  let title: String
  let description: String
  let reviews: Reviews
//  let duration: ActivityDuration
  
  enum CodingKeys: String, CodingKey {
    case id = "productCode"
    case title
    case description
    case reviews
//    case duration
  }
}

struct Activities: Codable {
  let items: [Activity]
  
  enum CodingKeys: String, CodingKey {
    case items = "products"
  }
}

struct Viator {
    let baseURL = "https://api.viator.com/partner"
    let apiKey = "28ed06aa-9937-4a5e-9b9c-a992d05649a1"
    let headers: HTTPHeaders
    
    init() {
        self.headers = [
            "exp-api-key": apiKey,
            "Accept-Language": "en-us",
            "Content-Type": "application/json",
            "Accept": "application/json;version=2.0",
            "currency": "USD"
        ]
    }
  
  func searchActivities() async -> [Activity] {
    let url = baseURL + "/products/search"
    
    let parameters: [String: Any] = [
                "filtering": [
                    "destination": "732",
                    "tags": [21972],
                    "flags": ["LIKELY_TO_SELL_OUT", "FREE_CANCELLATION"],
                    "lowestPrice": 5,
                    "highestPrice": 500,
                    "startDate": "2024-10-20",
                    "endDate": "2024-10-24",
                    "includeAutomaticTranslations": true,
                    "confirmationType": "INSTANT",
                    "durationInMinutes": [
                        "from": 20,
                        "to": 360
                    ],
                    "rating": [
                        "from": 3,
                        "to": 5
                    ]
                ],
                "sorting": [
                    "sort": "TRAVELER_RATING",
                    "order": "DESCENDING"
                ],
                "pagination": [
                    "start": 1,
                    "count": 5
                ],
                "currency": "USD"
            ]
    
    let response = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    let activities = try? await response.serializingDecodable(Activities.self).value
    return activities?.items ?? []
  }
  
}
