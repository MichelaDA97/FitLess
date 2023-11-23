
//  SummaryView.swift
//  FitnessApp
//
//  Created by Michela D'Avino on 15/11/23.
//

import SwiftUI



struct SummaryView: View {
    
    
    @EnvironmentObject var manager : HealthManager
    
    // @Binding var goalCalories : Double
    
    
    
    
    //settare data
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        //giorno in lettere, giorno in numero, diminutivo mese e anno intero
        dateFormatter.dateFormat = "EE, dd MMM"
        
        return dateFormatter.string(from: Date())
    }
    
    
    func createFooter() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 60) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Steps")
                        .font(Font.system(size: 18, weight: .regular, design: .default))
                    
                    
                    Text("\(manager.stepValue)")
                        .font(Font.system(size: 28, weight: .semibold, design: .rounded))
                    
                        .padding([.top], -3)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Distance")
                        .font(Font.system(size: 18, weight: .regular, design: .default))
                    
                    
                    (
                        Text(manager.formatDistance(manager.walkValue))
                            .font(Font.system(size: 28, weight: .semibold, design: .rounded))
                        
                        
                        + Text("KM")
                            .font(Font.system(size: 24, weight: .semibold, design: .rounded))
                        
                    )
                    .padding([.top], -3)
                }
                Spacer()
            }
            Divider()
                .frame(height: 2)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 15, trailing: 0))
            
            Text("Flights Climbed")
                .font(Font.system(size: 18, weight: .regular, design: .default))
             
            
            Text("4")
                .font(Font.system(size: 28, weight: .semibold, design: .rounded))
                .padding([.top], -3)
        }
        .padding([.leading], 15)
    }
    
    
    
    var body: some View {
        
     
        let goalCalories : Double = 200
        
        let percentage = Double(manager.caloriesValue)/goalCalories
        
        
        NavigationStack{
            
            
            
            
            
            VStack{
                
                
                
                ZStack{
                    RingView(percentage: percentage, backgroundColor: Color(red: 0.2, green: 0.11, blue: 0.15), endColor: Color(.ringProgress), thickness: 25)
                        .accessibility(hint: Text("Progress: \(Int(percentage * 100))%"))
                        .frame(width: 200, height: 200)
                    
                    Image(systemName: "arrow.forward")
                        .rotationEffect(.degrees(0))
                        .offset(x:0, y:-75)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    
                    
                }
                
                VStack(alignment: .leading){
                
                    Text("Move")
                        .font(Font.system(size: 18, weight: .regular, design: .default))
                    
                    Text("\(manager.caloriesValue)/\(Int(goalCalories))")
                        .font(Font.system(size: 28, weight: .medium, design: .default))
                        .foregroundColor(Color(red: 1, green: 0.18, blue: 0.33))
                    +
                    Text("KCAL")
                        .font(Font.system(size: 18, weight: .regular, design: .default))
                        .foregroundColor(Color(red: 1, green: 0.18, blue: 0.33))
                }.padding(.horizontal, -181 )
                
                
                
                ChartView()
                    .environmentObject(manager)
                    .onAppear {
                        manager.fetchHourCalories {
                            hourCalories in
                            DispatchQueue.main.async {
                                manager.hourCount = hourCalories
                            }
                        }
                    }
                
           
                
                createFooter()
                
                Button(){
                    } label: {
                        Text("Change Move Goal").fontWeight(.bold)
                    }
                    .frame(width: 200, height: 50)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.11))
                    .cornerRadius(10)
                
                
            }
            
        }
        .navigationBarTitle(formatDate(), displayMode: .inline)
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarTrailing){
                
                Button(){
                }label: {
                    Image(systemName: "calendar")
                }
                //end primo bottone
                
                Button(){
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                //end secondo bottone
            }
        }
        //end toolbar
        .environment(\.colorScheme, .dark)
        
    }
}


