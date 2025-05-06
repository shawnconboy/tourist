import SwiftUI
import Combine

struct HomeView: View {
    @Binding var selectedTab: Int
    @State private var featured: [Place] = []
    @State private var events: [Event] = []
    @State private var searchText = ""
    @StateObject private var weatherService = WeatherService()

    var matchingPlaces: [Place] {
        if searchText.isEmpty { return [] }

        let lowercasedQuery = searchText.lowercased()

        return featured
            .filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                ($0.tags?.contains(where: { $0.localizedCaseInsensitiveContains(searchText) }) ?? false)
            }
            .sorted {
                let nameA = $0.name.lowercased()
                let nameB = $1.name.lowercased()

                let aStartsWith = nameA.hasPrefix(lowercasedQuery)
                let bStartsWith = nameB.hasPrefix(lowercasedQuery)

                if aStartsWith != bStartsWith {
                    return aStartsWith
                }

                return nameA < nameB
            }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Header with Weather
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Welcome to Charleston")
                                .titleStyle()
                            Text("Discover beaches, bites, and adventures with our curated guide.")
                                .subtitleStyle()
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: weatherService.icon)
                                .foregroundColor(.blue)
                            Text(weatherService.temperature)
                                .font(.subheadline)
                        }
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, Layout.horizontalPadding)
                    .padding(.top)

                    // Search Bar
                    TextField("Search for restaurants, beaches, or bars", text: $searchText)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, Layout.horizontalPadding)

                    // Search Suggestions
                    if !matchingPlaces.isEmpty {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(matchingPlaces) { place in
                                NavigationLink(destination: PlaceDetailView(place: place)) {
                                    HStack {
                                        Text(place.name)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color(.systemBackground))
                                }
                                .buttonStyle(PlainButtonStyle())

                                Divider()
                            }
                        }
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, Layout.horizontalPadding)
                    }

                    // Top Shortcut Row
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(TopShortcut.allCases, id: \.self) { shortcut in
                                Button(action: {
                                    selectedTab = shortcut.tabIndex
                                }) {
                                    VStack(spacing: 10) {
                                        Image(systemName: shortcut.icon)
                                            .font(.system(size: 28))
                                            .foregroundColor(.white)
                                            .frame(width: 52, height: 52)
                                            .background(shortcut.color)
                                            .clipShape(Circle())

                                        Text(shortcut.title)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .frame(width: 70)
                                    }
                                    .padding()
                                    .frame(width: 90, height: 110)
                                    .background(Theme.darkBlue)
                                    .cornerRadius(Layout.cornerRadius)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, Layout.horizontalPadding)
                    }

                    // Featured Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Places to Visit")
                            .sectionTitleStyle()

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(featured) { place in
                                    FeaturedPlaceCard(place: place)
                                }
                            }
                            .padding(.horizontal, Layout.horizontalPadding)
                        }
                    }

                    // Live Events Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Live Events")
                            .sectionTitleStyle()
                            .padding(.horizontal, Layout.horizontalPadding)

                        ForEach(events) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(event.title)
                                        .font(.headline)

                                    HStack {
                                        Text(event.date)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text(event.location)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    Text(event.price)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, Layout.horizontalPadding)
                        }
                    }

                    Spacer(minLength: 40)
                }
            }
            .navigationTitle("Home")
            .onAppear {
                featured = loadFeaturedPlaces()
                events = loadEvents()
                weatherService.fetchWeather(lat: 32.7765, lon: -79.9311) // Charleston
            }
            .onReceive(NotificationCenter.default.publisher(for: .didNavigateToPlace)) { _ in
                searchText = ""
            }
        }
    }

    func loadFeaturedPlaces() -> [Place] {
        guard let url = Bundle.main.url(forResource: "allPlaces", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Place].self, from: data) else {
            return []
        }
        return decoded
    }

    func loadEvents() -> [Event] {
        guard let url = Bundle.main.url(forResource: "events", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Event].self, from: data) else {
            return []
        }
        return decoded
    }

    struct FeaturedPlaceCard: View {
        let place: Place

        var body: some View {
            NavigationLink(destination: PlaceDetailView(place: place)) {
                VStack(alignment: .leading, spacing: 6) {
                    Image(place.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 240, height: 140)
                        .clipped()
                        .cornerRadius(Layout.cornerRadius)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(place.name)
                            .font(.headline)
                            .lineLimit(1)
                            .truncationMode(.tail)

                        Text(place.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.bottom, 8)
                .frame(width: 240, alignment: .leading)
                .background(Color(.systemBackground))
                .cornerRadius(Layout.cornerRadius)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    enum TopShortcut: CaseIterable, Hashable {
        case deals, food, beaches, things

        var title: String {
            switch self {
            case .deals: return "Deals"
            case .food: return "Food & Drink"
            case .beaches: return "Beaches"
            case .things: return "Things To Do"
            }
        }

        var icon: String {
            switch self {
            case .deals: return "flame.fill"
            case .food: return "fork.knife"
            case .beaches: return "sun.max.fill"
            case .things: return "star.fill"
            }
        }

        var color: Color {
            switch self {
            case .deals: return .green
            case .food: return .orange
            case .beaches: return .blue
            case .things: return .purple
            }
        }

        var tabIndex: Int {
            switch self {
            case .deals: return 1
            case .food: return 2
            case .beaches: return 3
            case .things: return 4
            }
        }
    }
}

struct Event: Identifiable, Codable {
    let id: String
    let title: String
    let date: String
    let location: String
    let price: String
}

extension Notification.Name {
    static let didNavigateToPlace = Notification.Name("didNavigateToPlace")
}
