
//  HealthManager.swift
//  FitnessApp
//
//  Created by Michela D'Avino on 17/11/23.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay : Date{
        Calendar.current.startOfDay(for: Date())
    }
}


struct HourCalory : Identifiable{
    let id = UUID()
    let data : Date
    let caloriesCount : Double
}

class HealthManager : ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var caloriesValue : Int = 0
    @Published var stepValue : Int = 0
    @Published var walkValue : Double = 0
    @Published var hourCount : [HourCalory] = []
    
    
 

    init(){
        
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let distance = HKQuantityType(.distanceWalkingRunning)
        
        
        let healthTypes : Set = [steps, calories, distance]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchStep(quantityTypeIdentifier: .stepCount)
                fetchDistance(quantityTypeIdentifier: .distanceWalkingRunning)
                fetchEnergyBurned(quantityTypeIdentifier: .activeEnergyBurned)
            } catch {
                print("error fetching health data")
            }
        }
    }
    
    
    
    func fetchHourCalories(completion: @escaping ([HourCalory]) -> Void) {
            let calories = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!

            let calendar = Calendar.current
            let currentDate = Date()
            let startDate = calendar.startOfDay(for: currentDate)
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!

            let interval = DateComponents(hour: 1)
            let anchorDate = calendar.startOfDay(for: startDate)

            let query = HKStatisticsCollectionQuery(quantityType: calories, quantitySamplePredicate: nil, anchorDate: anchorDate, intervalComponents: interval)

            query.initialResultsHandler = { query, result, error in
                guard let result = result, error == nil else {
                    print("Error fetching hourly calorie data")
                    completion([])
                    return
                }

                var hourCalories = [HourCalory]()

                result.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                    let endDate = statistics.endDate
                    let caloriesValue = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0.0
                    hourCalories.append(HourCalory(data: endDate, caloriesCount: caloriesValue))

                
                }

                completion(hourCalories)
            }

            healthStore.execute(query)
        }
    
    func fetchStep(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        let step = HKObjectType.quantityType(forIdentifier: .stepCount)!
        
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let now = Date()
            let predicate = HKQuery.predicateForSamples(withStart: today, end: now, options: .strictStartDate)
            let statisticsOptions: HKStatisticsOptions = .cumulativeSum

            let query = HKStatisticsQuery(quantityType: step, quantitySamplePredicate: predicate, options: statisticsOptions) {
                (query, result, error) in
                if let result = result, let sumQuantity = result.sumQuantity() {
                    let totalStep = sumQuantity.doubleValue(for: HKUnit.count())

                    DispatchQueue.main.async {
                        self.stepValue = Int(totalStep)
                    }
                } else {
                    print("Failed to fetch total step: \(error?.localizedDescription ?? "")")
                }
            }

            healthStore.execute(query)
        }
    
    
    
    func fetchEnergyBurned(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
            let energyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let now = Date()
            let predicate = HKQuery.predicateForSamples(withStart: today, end: now, options: .strictStartDate)
            let statisticsOptions: HKStatisticsOptions = .cumulativeSum

            let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: statisticsOptions) { (query, result, error) in
                if let result = result, let sumQuantity = result.sumQuantity() {
                    let totalEnergyBurned = sumQuantity.doubleValue(for: HKUnit.kilocalorie())

                    DispatchQueue.main.async {
                        self.caloriesValue = Int(totalEnergyBurned)
                    }
                } else {
                    print("Failed to fetch total energy burned: \(error?.localizedDescription ?? "")")
                }
            }

            healthStore.execute(query)
        }
    
    
//    func fetchTodayCalories(completion: @escaping (Double) -> Void){
//
//        let calories = HKQuantityType(.activeEnergyBurned)
//
//        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
//        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate){
//            _, result, error in
//
//            guard let quantity = result?.sumQuantity(), error == nil else {
//                print("Error fetching todays calories data")
//                return
//            }
//
//            let caloriesCount = quantity.doubleValue(for: .kilocalorie())
//
//            DispatchQueue.main.async {
//                completion(caloriesCount)
//            }
//
//
//        }
//
//
//        healthStore.execute(query)
//
//
//    }
//
    
    
    //visualizzare solo le prime due cifre dopo la virgola per la Distance
    func formatDistance(_ distance: Double) -> String {
        return String(format: "%.2f", distance)
    }
    
    
    func fetchDistance(quantityTypeIdentifier: HKQuantityTypeIdentifier){
        
        let distance  = HKQuantityType(.distanceWalkingRunning)
        
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        let statisticsOptions: HKStatisticsOptions = .cumulativeSum
        
        let query = HKStatisticsQuery(quantityType: distance, quantitySamplePredicate: predicate, options: statisticsOptions) {
            (query, result, error) in
            
            if let result = result, let sumQuantity = result.sumQuantity() {
                let totalDistance = sumQuantity.doubleValue(for: HKUnit.meterUnit(with: .kilo))

                DispatchQueue.main.async {
        
                    self.walkValue = totalDistance
                }
            } else {
                print("Failed to fetch total distance: \(error?.localizedDescription ?? "")")
            }
        }

        healthStore.execute(query)
    }

    
    
   
    
    

    
}


