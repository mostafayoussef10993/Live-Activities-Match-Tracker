import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
    public typealias LiveDeliveryData = ContentState

    public struct ContentState: Codable, Hashable {
        var appGroupId: String
    }

    var id = UUID()
}

extension LiveActivitiesAppAttributes {
    func prefixedKey(_ key: String) -> String {
        return "\(id)_\(key)"
    }
}

struct FootballLiveActivityView: View {
    let context: ActivityViewContext<LiveActivitiesAppAttributes>

    let sharedDefault = UserDefaults(suiteName: "group.com.youssef.liveactivities.4463737337")!

    var teamAName: String { sharedDefault.string(forKey: context.attributes.prefixedKey("teamAName")) ?? "PSG" }
    var teamBName: String { sharedDefault.string(forKey: context.attributes.prefixedKey("teamBName")) ?? "Chelsea" }
    var teamAScore: Int { sharedDefault.integer(forKey: context.attributes.prefixedKey("teamAScore")) }
    var teamBScore: Int { sharedDefault.integer(forKey: context.attributes.prefixedKey("teamBScore")) }

    var body: some View {
        HStack {
            // Team A
            VStack(spacing: 4) {
                Image("psg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                Text(teamAName)
                    .font(.caption)
                    .foregroundColor(.white)
            }

            Spacer()

            // Score
            VStack(spacing: 2) {
                Text("\(teamAScore) : \(teamBScore)")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }

            Spacer()

            // Team B
            VStack(spacing: 4) {
                Image("che")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                Text(teamBName)
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.black)
    }
}

struct FootballLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            FootballLiveActivityView(context: context)
        } dynamicIsland: { context in
            let shared = UserDefaults(suiteName: "group.com.youssef.liveactivities.4463737337")!
            let teamA = shared.string(forKey: context.attributes.prefixedKey("teamAName")) ?? "PSG"
            let teamB = shared.string(forKey: context.attributes.prefixedKey("teamBName")) ?? "Chelsea"
            let scoreA = shared.integer(forKey: context.attributes.prefixedKey("teamAScore"))
            let scoreB = shared.integer(forKey: context.attributes.prefixedKey("teamBScore"))

            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(spacing: 2) {
                        Image("psg")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        Text(teamA)
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(spacing: 2) {
                        Image("che")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        Text(teamB)
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("\(scoreA)  :  \(scoreB)")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("⚽ Live Match")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
            } compactLeading: {
                Image("psg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
            } compactTrailing: {
                Image("che")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
            } minimal: {
                Text("⚽")
                    .font(.caption)
            }
        }
    }
}