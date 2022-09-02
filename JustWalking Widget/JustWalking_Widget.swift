//
//  JustWalking_Widget.swift
//  JustWalking Widget
//
//  Created by Ryan on 2022/09/02.
//

import WidgetKit
import SwiftUI

struct StepEntry: TimelineEntry {
    var date: Date = Date()
    var steps: Int
}

struct Provider: TimelineProvider {
    typealias Entry = StepEntry

    @AppStorage("stepCount", store: UserDefaults(suiteName: "group.com.ryan.justwalking.JustWalking")) var stepCount: Int = 0
    
    func placeholder(in context: Context) -> StepEntry {
        let entry = StepEntry(steps: stepCount)
        return entry
    }

    func getSnapshot(in context: Context, completion: @escaping (StepEntry) -> Void) {
        let entry = StepEntry(steps: stepCount)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StepEntry>) -> Void) {
        let entry = StepEntry(steps: stepCount)
        completion(Timeline(entries: [entry], policy: .atEnd))
    }
}

struct StepView: View {
    let entry: Provider.Entry

    var body: some View {
        Text("\(entry.steps)")
    }
}

@main
struct StepWidget: Widget {
    private let kind = "StepWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StepView(entry: entry)
        }
    }
}




