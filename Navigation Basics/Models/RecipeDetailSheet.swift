// RecipeDetailSheet.swift
//
// Portable detail sheet that is used in multiple views.
//
// Based on MovieDetailSheet introduced in Lab04.

import SwiftUI

struct RecipeDetailSheet: View {

    let recipe: TheMealDB.Meal

    @Environment(\.dismiss) private var dismiss

    @State private var detail: TheMealDB.MealDetail?
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                AsyncImage(url: URL(string: recipe.strMealThumb ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 220)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(recipe.strMeal)
                    .font(.title2)
                    .fontWeight(.bold)

                if let detail {

                    Text("Category: \(detail.fields["strCategory"] ?? "N/A")")
                    Text("Area: \(detail.fields["strArea"] ?? "N/A")")

                    Text("Ingredients")
                        .font(.headline)
                    Text(detail.ingredients.map { "• \($0.measure) \($0.name)" }.joined(separator: "\n"))

                    Text("Instructions")
                        .font(.headline)
                    Text(detail.fields["strInstructions"] ?? "No instructions available.")

                } else if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                } else {
                    ProgressView("Loading recipe...")
                }

                Button("Close") {
                    dismiss()
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .presentationBackground(Color.appSecondaryBackground)
        .task {
            do {
                detail = try await TheMealDB.shared.lookupMeal(id: recipe.id)
            } catch {
                errorMessage = "Couldn't load this recipe. Check your internet connection and try again."
            }
        }
    }
}
