
import SwiftUI

struct HomePageView: View {

    @State private var searchText = ""
    @State private var selectedCategory = "All"

    private let recipes = MockRecipeData.recipes

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

    private var filteredRecipes: [SearchRecipe] {

        recipes.filter { recipe in

            let matchesCategory =
                selectedCategory == "All" ||
                recipe.category == selectedCategory

            let matchesSearch =
                searchText.isEmpty ||
                recipe.name.localizedCaseInsensitiveContains(searchText)

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

                    if let featured = recipes.first {

                        VStack(alignment: .leading, spacing: 14) {

                            Text("Today's Pick")
                                .font(.title2)
                                .fontWeight(.bold)

                            ZStack(alignment: .bottomLeading) {

                                AsyncImage(
                                    url: URL(
                                        string: "https://images.unsplash.com/\(featured.image)?w=900"
                                    )
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

                                    Text(featured.name)
                                        .font(.title2)
                                        .fontWeight(.bold)

                                    Text("\(featured.time) • \(featured.category)")
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
                                        url: URL(
                                            string: "https://images.unsplash.com/\(recipe.image)?w=500"
                                        )
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

                                    Text(recipe.name)
                                        .font(.system(size: 15, weight: .semibold))
                                        .lineLimit(2)

                                    HStack {

                                        Text(recipe.category)

                                        Spacer()

                                        Text(recipe.time)
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
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    HomePageView()
}
