import SwiftUI

struct HomePageView: View {

    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var meals: [TheMealDB.Meal] = []

    @AppStorage("currentUsername") private var currentUsername = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var favoriteRecipes: [TheMealDB.Meal] = []

    private var favoritesKey: String {
        "favoriteRecipes_\(currentUsername)"
    }

    private let backgroundColor = Color(
        red: 0.98,
        green: 0.96,
        blue: 0.92
    )

    private let accentColor = Color(
        red: 0.78,
        green: 0.35,
        blue: 0.23
    )

    private let categories = [
        "All", "Breakfast", "Lunch", "Dinner"
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    private var filteredRecipes: [TheMealDB.Meal] {

        meals.filter { recipe in

            let matchesCategory =
                selectedCategory == "All" ||
                recipe.strCategory == selectedCategory

            let matchesSearch =
                searchText.isEmpty ||
                recipe.strMeal.localizedCaseInsensitiveContains(searchText)

            return matchesCategory && matchesSearch
        }
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 25) {

                    // MARK: - Header

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Welcome to RecipeApp")
                            .font(.system(size: 32, weight: .bold))

                        Text("Discover something delicious today.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // MARK: - Featured Recipe

                    if let featured = meals.first {

                        VStack(alignment: .leading, spacing: 14) {

                            Text("Today's Pick")
                                .font(.title2)
                                .fontWeight(.bold)

                            ZStack(alignment: .bottomLeading) {

                                AsyncImage(
                                    url: URL(string: featured.strMealThumb ?? "")
                                ) { image in

                                    image
                                        .resizable()
                                        .scaledToFill()

                                } placeholder: {

                                    Rectangle()
                                        .fill(.gray.opacity(0.2))
                                        .overlay {
                                            ProgressView()
                                        }
                                }
                                .frame(height: 220)
                                .frame(maxWidth: .infinity)
                                .clipped()

                                LinearGradient(
                                    colors: [
                                        .clear,
                                        .black.opacity(0.75)
                                    ],
                                    startPoint: .center,
                                    endPoint: .bottom
                                )

                                VStack(alignment: .leading, spacing: 6) {

                                    Text("FEATURED RECIPE")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .tracking(1.5)

                                    Text(featured.strMeal)
                                        .font(.title2)
                                        .fontWeight(.bold)

                                    Text(featured.strCategory ?? "")
                                        .font(.caption)
                                }
                                .foregroundStyle(.white)
                                .padding(18)
                            }
                            .clipShape(
                                RoundedRectangle(cornerRadius: 20)
                            )
                        }
                    }

                    // MARK: - Categories

                    VStack(alignment: .leading, spacing: 14) {

                        Text("Categories")
                            .font(.title2)
                            .fontWeight(.bold)

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
                                            .padding(.horizontal, 18)
                                            .padding(.vertical, 11)
                                            .foregroundStyle(
                                                selectedCategory == category
                                                ? .white
                                                : Color.black.opacity(0.7)
                                            )
                                            .background(
                                                selectedCategory == category
                                                ? accentColor
                                                : .white
                                            )
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    // MARK: - Popular Recipes

                    VStack(alignment: .leading, spacing: 14) {

                        HStack {

                            Text("Popular Recipes")
                                .font(.title2)
                                .fontWeight(.bold)

                            Spacer()

                            Text("\(filteredRecipes.count) recipes")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        LazyVGrid(
                            columns: columns,
                            spacing: 16
                        ) {

                            ForEach(filteredRecipes) { recipe in

                                VStack(alignment: .leading, spacing: 8) {

                                    AsyncImage(
                                        url: URL(string: recipe.strMealThumb ?? "")
                                    ) { image in

                                        image
                                            .resizable()
                                            .scaledToFill()

                                    } placeholder: {

                                        Rectangle()
                                            .fill(.gray.opacity(0.2))
                                            .overlay {
                                                ProgressView()
                                            }
                                    }
                                    .frame(height: 125)
                                    .frame(maxWidth: .infinity)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 15)
                                    )
                                    .overlay(alignment: .topTrailing) {
                                        if isLoggedIn {
                                            Button {
                                                toggleFavorite(recipe)
                                            } label: {
                                                Image(systemName: isFavorite(recipe) ? "heart.fill" : "heart")
                                                    .foregroundStyle(accentColor)
                                                    .padding(8)
                                                    .background(.white, in: Circle())
                                            }
                                            .padding(6)
                                        }
                                    }

                                    Text(recipe.strMeal)
                                        .font(.system(size: 15, weight: .semibold))
                                        .lineLimit(2)

                                    HStack {

                                        Text(recipe.strCategory ?? "")
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }
                                .padding(10)
                                .background(.white)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 18)
                                )
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(backgroundColor)
            .task { meals = (try? await TheMealDB.shared.searchMeals(query: "Thai")) ?? [] }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear { loadFavorites() }
        }
    }

    // MARK: - Favorites

    private func loadFavorites() {
        guard isLoggedIn, !currentUsername.isEmpty,
              let data = UserDefaults.standard.data(forKey: favoritesKey),
              let decoded = try? JSONDecoder().decode([TheMealDB.Meal].self, from: data) else {
            favoriteRecipes = []
            return
        }
        favoriteRecipes = decoded
    }

    private func saveFavorites() {
        guard isLoggedIn, !currentUsername.isEmpty else { return }
        if let data = try? JSONEncoder().encode(favoriteRecipes) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }

    private func isFavorite(_ recipe: TheMealDB.Meal) -> Bool {
        favoriteRecipes.contains { $0.id == recipe.id }
    }

    private func toggleFavorite(_ recipe: TheMealDB.Meal) {
        if isFavorite(recipe) {
            favoriteRecipes.removeAll { $0.id == recipe.id }
        } else {
            favoriteRecipes.append(recipe)
        }
        saveFavorites()
    }
}

#Preview {
    HomePageView()
}
