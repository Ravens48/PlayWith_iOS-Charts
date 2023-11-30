
import Foundation

struct dayAndCode: Codable {
    let day: String
    let code: String
}

// MARK: - Welcome
struct Top: Codable {
    let dailyInfluxDto: [DailyInfluxDto]
}

// MARK: - DailyInfluxDto
struct DailyInfluxDto: Codable {
    let day: String
    let influx: [Influx]
}

// MARK: - Influx
struct Influx: Codable {
    let influxAsNumeric: Int
    let influxAsEnum: InfluxAsEnum
    let influxAsString: InfluxAsString
    let start, end: Int
}

enum InfluxAsEnum: String, Codable {
    case high = "high"
    case low = "low"
    case medium = "medium"
    case nothing = "nothing"
    case veryhigh = "veryhigh"
    case verylow = "verylow"
}

enum InfluxAsString: String, Codable {
    case actuellementFermé = "Actuellement fermé"
    case assezFréquenté = "Assez fréquenté"
    case fréquenté = "Fréquenté"
    case peuFréquenté = "Peu fréquenté"
    case trèsFréquenté = "Très fréquenté"
    case trèsPeuFréquenté = "Très peu fréquenté"
}
