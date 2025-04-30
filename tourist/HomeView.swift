import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Int
    @State private var featured: [Place] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome to Charleston")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Discover beaches, bites, and adventures with our curated guide.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Category Shortcuts
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(QuickCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    selectedTab = category.tabIndex
                                }) {
                                    VStack(spacing: 8) {
                                        Image(systemName: category.icon)
                                            .font(.title2)
                                            .padding()
                                            .background(Color.green.opacity(0.15))
                                            .clipShape(Circle())
                                        Text(category.rawValue)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Featured Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Places to Visit")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(featured) { place in
                                    FeaturedPlaceCard(place: place)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Widget-style Grid Tiles
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Explore by Category")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(HomeTile.sampleTiles) { tile in
                                Button(action: {
                                    selectedTab = tile.tabIndex
                                }) {
                                    VStack(spacing: 12) {
                                        Image(systemName: tile.image)
                                            .font(.system(size: 28))
                                            .frame(width: 50, height: 50)
                                            .background(tile.color.opacity(0.15))
                                            .clipShape(Circle())
                                        Text(tile.title)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.systemBackground))
                                    .cornerRadius(14)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .navigationTitle("Home")
            .onAppear {
                featured = loadFeaturedPlaces()
            }
        }
    }
    
    // JSON loader
    func loadFeaturedPlaces() -> [Place] {
        guard let url = Bundle.main.url(forResource: "allPlaces", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Place].self, from: data) else {
            return []
        }
        return decoded
    }
    
    
    
    
    // MARK: - Featured Place Card using Place model
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
                        .cornerRadius(14)
                    
                    Text(place.name)
                        .font(.headline)
                    Text(place.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(width: 240)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    // MARK: - Category shortcuts
    enum QuickCategory: String, CaseIterable, Hashable {
        case bars = "Bars"
        case restaurants = "Restaurants"
        case beaches = "Beaches"
        case history = "History"
        
        var icon: String {
            switch self {
            case .bars: return "wineglass.fill"
            case .restaurants: return "fork.knife"
            case .beaches: return "sun.max.fill"
            case .history: return "book.fill"
            }
        }
        
        var tabIndex: Int {
            switch self {
            case .bars, .restaurants: return 2
            case .beaches: return 1
            case .history: return 3
            }
        }
    }
    
    // MARK: - Widget-style tiles
    struct HomeTile: Identifiable {
        let id = UUID()
        let title: String
        let image: String
        let color: Color
        let tabIndex: Int
        
        static let sampleTiles: [HomeTile] = [
            .init(title: "Beaches", image: "sun.max.fill", color: .blue, tabIndex: 1),
            .init(title: "Food & Drink", image: "fork.knife", color: .orange, tabIndex: 2),
            .init(title: "Things To Do", image: "star.fill", color: .purple, tabIndex: 3),
            .init(title: "Deals", image: "flame.fill", color: .green, tabIndex: 4),
            .init(title: "Map", image: "map.fill", color: .pink, tabIndex: 5)
        ]
    }
}
