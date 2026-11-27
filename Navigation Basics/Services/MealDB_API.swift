// MeadDB_API.swift
//
// API for accessing TheMealDB
// No API credentials are stored since TheMealDB has a free public API
//
// Based on https://github.com/csuf-cpsc-411-fa26/CPSC411-Lab-06/blob/main/MoviePortal/Services/TMDBService.swift

import Foundation
 
// MARK: - Service Layer
class TheMealDB {
    static let shared = TheMealDB()
 
    // "1" is the public API key
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
 
    private init() {}
 
    // MARK: - Models
    struct Meal: Codable, Identifiable {
        let idMeal: String
        let strMeal: String
        let strCategory: String?
        let strMealThumb: String?
 
        var id: String { idMeal }
    }
 
    private struct MealResponse: Decodable {
        let meals: [Meal]?
    }

    // filter.php returns no strCategory, so the requested category is
    // filled in to keep the recipe cards and category checks working.
    func filterMeals(category: String) async throws -> [Meal] {
        guard let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/filter.php?c=\(encodedCategory)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let meals = try JSONDecoder().decode(MealResponse.self, from: data).meals ?? []

        return meals.map {
            Meal(idMeal: $0.idMeal, strMeal: $0.strMeal, strCategory: category, strMealThumb: $0.strMealThumb)
        }
    }

    // Full recipe from lookup.php. Every value in the meal JSON is a
    // string or null, so it decodes directly into a Dictionary.
    struct MealDetail {
        let fields: [String: String]

        init(_ raw: [String: String?]) {
            // Drop nulls and empty strings ("") the API uses for unused slots.
            fields = raw.compactMapValues { value in
                guard let text = value?.trimmingCharacters(in: .whitespacesAndNewlines),
                      !text.isEmpty else { return nil }
                return text
            }
        }

        // Pairs strIngredient1...20 with strMeasure1...20.
        var ingredients: [(name: String, measure: String)] {
            (1...20).compactMap { i in
                guard let name = fields["strIngredient\(i)"] else { return nil }
                return (name, fields["strMeasure\(i)"] ?? "")
            }
        }
    }

    private struct MealDetailResponse: Decodable {
        let meals: [[String: String?]]?
    }

    func lookupMeal(id: String) async throws -> MealDetail {
        guard let url = URL(string: "\(baseURL)/lookup.php?i=\(id)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        guard let meal = try JSONDecoder().decode(MealDetailResponse.self, from: data).meals?.first else {
            throw URLError(.cannotParseResponse)
        }

        return MealDetail(meal)
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
