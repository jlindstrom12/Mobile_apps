//
//  ContentView.swift
//  Viator
//
//  Created by Juan Pablo Urista on 10/10/24.
//

import SwiftUI
import Alamofire

struct ContentView: View {
  @State private var activities: [Activity] = []
  @State private var isLoading = false
  @State private var errorMessage: String?
  
  var body: some View {
    NavigationView {
      List {
        ForEach(activities) { activity in
          VStack(alignment: .leading) {
            Text(activity.title)
              .font(.headline)
            Text(activity.description)
              .font(.caption)
              .font(.subheadline)
              .lineLimit(2)
          }
        }
        
      }.navigationTitle("Viator Activities")
        .onAppear(perform: loadActivities)
    }
  }
    
    func loadActivities() {
      Task{
        let viator = Viator()
        if let fetchedActivities = try? await viator.searchActivities() {
          DispatchQueue.main.async {
            self.activities = fetchedActivities
          }
        }
        
      }
    }
  }

#Preview {
    ContentView()
}
