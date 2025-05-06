import Foundation

struct WeatherData: Codable {
    let current_weather: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature: Double
    let weathercode: Int
}

class WeatherService: ObservableObject {
    @Published var temperature: String = "--"
    @Published var icon: String = "cloud.fill"

    func fetchWeather(lat: Double, lon: Double) {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current_weather=true&temperature_unit=fahrenheit"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                DispatchQueue.main.async {
                    let temp = Int(weatherData.current_weather.temperature.rounded())
                    self.temperature = "\(temp)°F"
                    self.icon = self.mapWeatherCodeToIcon(code: weatherData.current_weather.weathercode)
                }
            }
        }.resume()
    }

    private func mapWeatherCodeToIcon(code: Int) -> String {
        switch code {
        case 0: return "sun.max.fill"
        case 1, 2: return "cloud.sun.fill"
        case 3: return "cloud.fill"
        case 45, 48: return "cloud.fog.fill"
        case 51...67: return "cloud.drizzle.fill"
        case 71...77: return "cloud.snow.fill"
        case 80...82: return "cloud.heavyrain.fill"
        case 95...99: return "cloud.bolt.fill"
        default: return "cloud.fill"
        }
    }
}
