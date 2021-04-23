//
//  True_North_Tides_Widget.swift
//  True North Tides Widget
//
//  Created by Roddy Munro on 13/09/2020.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    typealias Entry = ReadingEntry
    
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), station: Station.dummy)
    }

    public func getSnapshot(for configuration: SelectStationIntent, in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = Entry(date: Date(), station: Station.dummy)
        completion(entry)
    }

    public func getTimeline(for configuration: SelectStationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let stationRepository = StationRepository(api: StationAPI(), defaultStationId: configuration.station?.identifier)
        
        stationRepository.getHiLoTides { result in
            switch result {
                case .success(let readings):
                    var nextRefresh: Date
                    if let reading = readings.first(where: { $0.isFuture }) {
                        if reading.dateTime < Date().addingTimeInterval(900) {
                            nextRefresh = reading.dateTime
                        } else {
                            nextRefresh = Date().addingTimeInterval(900)
                        }
                    } else {
                        nextRefresh = Date().addingTimeInterval(900)
                    }
                    
                    let entries: [Entry] = [
                        Entry(date: Date(), station: stationRepository.selectedStation),
                        Entry(date: nextRefresh, station: stationRepository.selectedStation)
                    ]

                    let timeline = Timeline(entries: entries, policy: .after(nextRefresh))
                    completion(timeline)
                case .failure:
                    let entries: [Entry] = []
                    let timeline = Timeline(entries: entries, policy: .atEnd)
                    completion(timeline)
            }
        }
    }
}

struct ReadingEntry: TimelineEntry {
    let date: Date
    let station: Station
}

struct True_North_Tides_WidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        VStack {
            switch family {
                case .systemSmall: TNTSmallWidget(station: entry.station)
                default: TNTMediumWidget(station: entry.station)
            }
        }
    }
}

struct TNTSmallWidget: View {
    var station: Station
    var tideType: TideType {
        if let idx = station.readings.firstIndex(where: { $0.isFuture }) {
            if station.readings[idx].convertedHeight < station.readings[idx+1].convertedHeight {
                return .low
            } else {
                return .high
            }
        }
        return .high
    }
    
    var body: some View {
        VStack(alignment: .center) {
            CircularProgressView(tideType: tideType, station: station)
                .frame(width: 110.0, height: 110.0)
                .padding(8)
            Text(station.displayName).font(.caption).fontWeight(.semibold)
        }
    }
}

struct TNTMediumWidget: View {
    var station: Station
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                CircularProgressView(tideType: .low, station: station)
                    .frame(width: 110.0, height: 110.0)
                    .padding(8)
                Spacer()
                CircularProgressView(tideType: .high, station: station)
                    .frame(width: 110.0, height: 110.0)
                    .padding(8)
                Spacer()
            }
            Text(station.displayName).font(.caption).fontWeight(.semibold)
        }
    }
}

@main
struct True_North_Tides_Widget: Widget {
    let kind: String = "True_North_Tides_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectStationIntent.self, provider: Provider()) { entry in
            True_North_Tides_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("True North Tides Widget")
        .description("This widget will show you the upcoming high and low tides for your selected station.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct True_North_Tides_Widget_Previews: PreviewProvider {
    
    static var previews: some View {
        True_North_Tides_WidgetEntryView(entry: ReadingEntry(date: Date(), station: Station.dummy))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        True_North_Tides_WidgetEntryView(entry: ReadingEntry(date: Date(), station: Station.dummy))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
