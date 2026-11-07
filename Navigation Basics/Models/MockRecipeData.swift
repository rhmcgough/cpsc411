
import Foundation

struct SearchRecipe: Identifiable {

    let id = UUID()
    let name: String
    let category: String
    let time: String
    let image: String
}

struct MockRecipeData {

    static let recipes: [SearchRecipe] = [

        SearchRecipe(
            name: "Avocado Toast",
            category: "Breakfast",
            time: "10 min",
            image: "photo-1525351484163-7529414344d8"
        ),

        SearchRecipe(
            name: "Blueberry Pancakes",
            category: "Breakfast",
            time: "15 min",
            image: "photo-1528207776546-365bb710ee93"
        ),

        SearchRecipe(
            name: "Fresh Salmon Bowl",
            category: "Lunch",
            time: "20 min",
            image: "photo-1512621776951-a57141f2eefd"
        ),

        SearchRecipe(
            name: "Grilled Chicken",
            category: "Dinner",
            time: "30 min",
            image: "photo-1547592180-85f173990554"
        ),

        SearchRecipe(
            name: "Creamy Garlic Pasta",
            category: "Dinner",
            time: "25 min",
            image: "photo-1473093295043-cdd812d0e601"
        ),

        SearchRecipe(
            name: "Garden Salad",
            category: "Vegetarian",
            time: "10 min",
            image: "photo-1512621776951-a57141f2eefd"
        )
    ]
}

