// Based on https://github.com/csuf-cpsc-411-fa26/CPSC411-Lab-06/blob/main/MoviePortal/Services/TMDBService.swift

import Foundation
 
// MARK: - Service Layer
class TheMealDB {
    static let shared = TheMealDB()
 
    // Public API, test key "1" is part of the URL
    // No API key required.
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
 
    private init() {}
 
    // MARK: - Models
    struct Meal: Decodable, Identifiable {
        let idMeal: String
        let strMeal: String
        let strCategory: String?
        let strMealThumb: String?
 
        var id: String { idMeal }
    }
 
    private struct MealResponse: Decodable {
        let meals: [Meal]?
    }
 

    func searchMeals(query: String) async throws -> [Meal] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/search.php?s=\(encodedQuery)") else {
            throw URLError(.badURL)
        }
 
        let (data, response) = try await URLSession.shared.data(from: url)
 
    
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }
 
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
 
        let mealResponse = try JSONDecoder().decode(MealResponse.self, from: data)
 
        print("Status:", httpResponse.statusCode)
        print("Meals:", mealResponse.meals?.count ?? 0)
 
        return mealResponse.meals ?? []
    }
}
