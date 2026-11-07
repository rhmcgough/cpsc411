import Foundation

struct Recipe: Identifiable {

    let id: String
    let name: String
    let imageURL: String
    let category: String
    let calories: Int
    let cookingTime: String
    let ingredients: [String]
}
