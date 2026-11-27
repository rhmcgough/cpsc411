import SwiftUI

struct SearchView: View {

    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var meals: [TheMealDB.Meal] = []
    @State private var selectedRecipe: TheMealDB.Meal?

    private let backgroundColor = Color.appBackground

    private let accentColor = Color(
        red: 0.78,
        green: 0.35,
        blue: 0.23
    )

    private let categories = [
        "All",
        "Breakfast",
        "Chicken",
        "Seafood",
        "Dessert",
        "Vegetarian",
    ]
    
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    private var filteredRecipes: [TheMealDB.Meal] {

        meals.filter { recipe in

            // search.php already matched the text; filter.php results still need it.
            selectedCategory == "All" ||
            searchText.isEmpty ||
            recipe.strMeal.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 24) {

                    // MARK: Header

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Explore recipes")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(.primary)

                        Text("Find something delicious to cook.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // MARK: Search Bar

                    HStack(spacing: 12) {

                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)

                        TextField(
                            "Search recipes or ingredients...",
                            text: $searchText
                        )
                        .autocorrectionDisabled()

                        if !searchText.isEmpty {

                            Button {
                                searchText = ""
                            } label: {

                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.appSecondaryBackground)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )

                    // MARK: Popular Searches

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Popular searches")
                            .font(.headline)

                        ScrollView(
                            .horizontal,
                            showsIndicators: false
                        ) {

                            HStack(spacing: 10) {

                                ForEach(
                                    ["Chicken", "Pasta", "Salmon", "Avocado"],
                                    id: \.self
                                ) { suggestion in

                                    Button {

                                        searchText = suggestion

                                    } label: {

                                        Text(suggestion)
                                            .font(.subheadline)
                                            .foregroundStyle(accentColor)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 9)
                                            .background(
                                                accentColor.opacity(0.10)
                                            )
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }

                    // MARK: Categories

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Categories")
                            .font(.headline)

                        ScrollView(
                            .horizontal,
                            showsIndicators: false
                        ) {

                            HStack(spacing: 10) {

                                ForEach(categories, id: \.self) { category in

                                    Button {

                                        selectedCategory = category

                                    } label: {

                                        Text(category)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundStyle(
                                                selectedCategory == category
                                                ? .white
                                                : .primary
                                            )
                                            .padding(.horizontal, 17)
                                            .padding(.vertical, 10)
                                            .background(
                                                selectedCategory == category
                                                ? accentColor
                                                : Color.appSecondaryBackground
                                            )
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }

                    // MARK: Recipe Results

                    VStack(alignment: .leading, spacing: 15) {

                        HStack {

                            Text(
                                searchText.isEmpty
                                ? "Discover recipes"
                                : "Search results"
                            )
                            .font(.title2)
                            .fontWeight(.bold)

                            Spacer()

                            Text("\(filteredRecipes.count) recipes")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        if filteredRecipes.isEmpty {

                            ContentUnavailableView(
                                "No recipes found",
                                systemImage: "magnifyingglass",
                                description: Text(
                                    "Try another search or category."
                                )
                            )
                            .padding(.top, 35)

                        } else {

                            LazyVGrid(
                                columns: columns,
                                spacing: 16
                            ) {

                                ForEach(filteredRecipes) { recipe in

                                    recipeCard(recipe)
                                        .contentShape(RoundedRectangle(cornerRadius: 18))
                                        .onTapGesture { selectedRecipe = recipe }
                                }
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(backgroundColor)
            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailSheet(recipe: recipe)
            }
            .task(id: [searchText, selectedCategory]) {
                guard !Task.isCancelled else { return }
                let results = selectedCategory == "All"
                    ? try? await TheMealDB.shared.searchMeals(query: searchText)
                    : try? await TheMealDB.shared.filterMeals(category: selectedCategory)
                if !Task.isCancelled { meals = results ?? [] }
            }
            
        }
    }

    // MARK: Recipe Card

    private func recipeCard(
        _ recipe: TheMealDB.Meal
    ) -> some View {

        VStack(alignment: .leading, spacing: 8) {

            AsyncImage(
                url: URL(string: recipe.strMealThumb ?? "")
            ) { image in

                image
                    .resizable()
                    .scaledToFill()

            } placeholder: {

                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray.opacity(0.15))
                    .overlay {
                        ProgressView()
                    }
            }
            .frame(height: 130)
            .frame(maxWidth: .infinity)
            .clipShape(
                RoundedRectangle(cornerRadius: 15)
            )

            Text(recipe.strMeal)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)

            HStack {

                Text(recipe.strCategory ?? "")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(Color.appSecondaryBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
    }
}

#Preview {
    SearchView()
}
