
//
//  ContentView.swift
//  FitnessApp
//
//  Created by Michela D'Avino on 15/11/23.
//

import SwiftUI




struct ContentView: View {
    
    
    @EnvironmentObject var manager : HealthManager
    
    @State var isAnimating = false
    
    
  
//    @State var goalCalories : Double = 200
    
    
    //settare data
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        //16 Nov 2023
        //dateFormatter.dateStyle = .medium
        
        dateFormatter.dateFormat = "EEEE, dd MMM"
        
        return dateFormatter.string(from: Date()).uppercased()
    }
    
  

    
    var body: some View {
        
    //    let calorie : Double = Double(manager.caloriesValue)
     //   let step : Int = manager.stepValue
     //   let distance : Double = Double(manager.walkValue)
        
        
        let goalCalories : Double = 200
        
        let perc = Double(manager.caloriesValue)/goalCalories
        
       
        
        NavigationView{
            
            
            ScrollView{
                
                
                
                
                //per impostare lo sfondo nero: includere nello zstack
                //Color.black.edgesIgnoringSafeArea(.all)
                
                
                VStack(alignment: .leading, spacing: 10){
                    
                    HStack(alignment: .bottom, spacing: 158){
                        
                        VStack(alignment: .leading, spacing: 8){
                            
                            Text(formatDate())
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(width: 140, height: 12, alignment: .leading)
                            
                            
                            
                            Text("Summary")
                            
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                            
                            
                        }
                        
                        
                        
                        Image("user")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 38, height: 38)
                            .clipShape(Circle())
                        
                        
                    }
                    
                    
                    
                    
                    Text("Activity")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    
                    
                    //raccoglitore cal-step-distanza
                    NavigationLink(destination: SummaryView()){
                        ZStack{
                            HStack(alignment: .center, spacing: 90){
                                VStack(alignment: .leading){
                                    Text("Move")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                    
                                    
                                    Text("\(manager.caloriesValue)" + "/\(Int(goalCalories))")
                                        .foregroundColor(Color(red: 1, green: 0.18, blue: 0.33))
                                    +
                                    Text("KCAL")
                                        .font(.caption)
                                        .foregroundColor(Color(red: 1, green: 0.18, blue: 0.33))
                                    
                                    
                                    Text("Steps")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                    Text("\(manager.stepValue)")
                                        .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.56))
                                    
                                    
                                    Text("Distance")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                    Text(manager.formatDistance(manager.walkValue))
                                        .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.56))
                                    +
                                    Text("KM")
                                        .font(.caption)
                                        .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.56))
                                    
                                    
                                    
                                }
                                //                            .onAppear{
                                //                                manager.fetchTodayStep{
                                //                                    steps in
                                //
                                //                                    todaySteps = Int(steps)
                                //                                }
                                //
                                //                                manager.fetchTodayCalories{
                                //                                    calories in
                                //
                                //                                    todayCalories = Int(calories)
                                //
                                //                                }
                                //
                                //                                manager.fetchDistance{
                                //                                    distance in
                                //
                                //                                    todayDistance = distance
                                //                                }
                                //                            }
                                //
                                
                                ZStack{
                                    RingView(percentage: perc, backgroundColor: Color(red: 0.2, green: 0.11, blue: 0.15), endColor: Color("ringProgress"), thickness: 25)
                                        .accessibility(hint: Text("Progress: \(Int(perc * 100))%"))
                                        
                                    
                                    
                                    
                                    Image(systemName: "arrow.forward")
                                        .rotationEffect(.degrees(0))
                                        .offset(x:1, y:-48)
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                    
                                    
                                }
                                
                                
                                
                                
                            }
                            .padding(.horizontal)
                        }
                        .frame(width: 360, height: 200)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.11))
                        .cornerRadius(10)
                        
                        
                    }
                    
                    HStack{
                        Text("History")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button("Show more"){
                            print("show more")
                        }
                    }
                    
                    //raccoglitore cronologia workout
                    HStack{
                        Image("workout")
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading){
                            Text("Outdoor Walk")
                                .font(.title3)
                            
                            HStack(alignment: .bottom, spacing: 142){
                                Text("1,02")
                                    .font(.title)
                                //  .fontWeight(.medium)
                                    .foregroundColor(.accentColor)
                                +
                                
                                Text("KM")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(.accentColor)
                                
                                //   Spacer()
                                
                                Text("14/09/23")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.56))
                                
                            }
                        }
                        
                        
                    }
                    .frame(width: 360, height: 70)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.11))
                    .cornerRadius(10)
                    
                    
                    
                    
                    Text("Trends")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    
                    
                    VStack(spacing: 40){
                        
                        Image(systemName: "figure.walk")
                            .foregroundColor(.accentColor)
                            .scaleEffect(isAnimating ? 2.5 : 1.0)
                            .animation(
                                Animation.linear(duration: 1)
                                    .repeatForever(autoreverses: true)
                            )
                            .onAppear() {
                                isAnimating = true
                            }
                        
                        
                        VStack(alignment: .leading){
                            Text("Closing your rings every day is a great way to stay active. Trend arrows help you stay motivated by showing even more details.")
                            
                            Button {
                                
                            } label: {
                                Text("Get started")
                            }
                        }
                        
                        
                    }
                    .frame(width: 360, height: 200)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.11))
                    .cornerRadius(10)
                    //    .padding(.vertical)
                    
                }
                
                .navigationTitle("Summary")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
                
            }
            
            .padding(.horizontal)
            
            
            
            
        }
        
        
        
        .environment(\.colorScheme, .dark)
        
    }
    
    
    
}





//
//#Preview {
//    ContentView()
//}
