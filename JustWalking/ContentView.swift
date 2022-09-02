//
//  ContentView.swift
//  JustWalking
//
//  Created by Ryan on 2022/09/02.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    
    private let pedometer: CMPedometer = CMPedometer()
    @State private var steps: Int?
    @State private var distance: Double?
    
    var body: some View {
        VStack {
            Text(steps != nil ? "\(steps!) steps" : "")
            Text(distance != nil ? String(format: "%.2f miles", distance!): "")
                .onAppear {
                    initializePedometer()
                }
        }
        .padding()
    }
    
    private func initializePedometer() {
        if isPedometerAvailable {
            guard let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return }
            pedometer.queryPedometerData(from: startDate, to: Date()) { data, error in
                guard let data = data, error == nil else { return }
                
                updateUI(data: data)
            }
        }
    }
    
    private var isPedometerAvailable: Bool {
        return CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable()
    }
        
    private func updateUI(data: CMPedometerData) {
        steps = data.numberOfSteps.intValue
        
        guard let pedometerDistance = data.distance else { return }
        
        let distanceInMeters = Measurement(value: pedometerDistance.doubleValue, unit: UnitLength.meters)
        distance = distanceInMeters.converted(to: .miles).value
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
