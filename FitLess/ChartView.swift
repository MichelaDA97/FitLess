//
//  ChartView.swift
//  FitLess
//
//  Created by Michela D'Avino on 22/11/23.
//



import SwiftUI
import Charts

struct ChartView: View {
    @EnvironmentObject var manager: HealthManager
    
    
    
    var body: some View {
        
            Chart {
                ForEach(manager.hourCount) {
                    hour in
                    BarMark(x: .value(hour.data.formatted(), hour.data, unit: .hour), y: .value("Calories", hour.caloriesCount))
                        .accessibilityLabel("Hour: \(hour.data.formatted()), Calories: \(hour.caloriesCount)")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            .foregroundColor(.ringProgress)
            
        
            
        
    }
}
