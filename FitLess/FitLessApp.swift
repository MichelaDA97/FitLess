//
//  FitLessApp.swift
//  FitLess
//
//  Created by Michela D'Avino on 22/11/23.
//

import SwiftUI

@main
struct FitLessApp: App {
    @StateObject var manager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            
            TabView{
                ContentView()
                    .tabItem {
                        
                        
                        Image(systemName: "s.circle")
                        Text("Summary")
                    }.environmentObject(manager)
                
                ContentView()
                    .tabItem {
                        Image(systemName: "figure.run.circle.fill")
                        Text("Fitness+")
                        
                    }.environmentObject(manager)
                
                ContentView()
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("Sharing")

                    }.environmentObject(manager)
            }
            
        }
    }
}
    
