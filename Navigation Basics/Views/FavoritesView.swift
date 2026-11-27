import SwiftUI

struct FavoritesView: View {

    @AppStorage("currentUsername")
    private var currentUsername = ""

    @AppStorage("isLoggedIn")
    private var isLoggedIn = false

    @State private var favoriteRecipes: [TheMealDB.Meal] = []

    private var favoritesKey: String {
        "favoriteRecipes_\(currentUsername)"
    }

    var body: some View {

        NavigationStack {

            VStack {

                if !isLoggedIn {

                    ContentUnavailableView(
                        "Please Log In",
                        systemImage: "lock.fill",
                        description: Text(
                            "Log in to view your saved recipes."
                        )
                    )

                } else if favoriteRecipes.isEmpty {

                    ContentUnavailableView(
                        "No Favorite Recipes",
                        systemImage: "heart.slash",
                        description: Text(
                            "Add recipes to your favorites by pressing the heart button"
                        )
                    )

                } else {

                    List {

                        ForEach(favoriteRecipes) { recipe in

                            HStack(spacing: 12) {

                                AsyncImage(
                                    url: URL(string: recipe.strMealThumb ?? "")
                                ) { image in

                                    image
                                        .resizable()
                                        .scaledToFill()

                                } placeholder: {

                                    ProgressView()
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 8)
                                )

                                VStack(
                                    alignment: .leading,
                                    spacing: 4
                                ) {

                                    Text(recipe.strMeal)
                                        .font(.headline)

                                    Text(recipe.strCategory ?? "")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Button {
                                    removeFavorite(recipe)
                                } label: {

                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                }
                                .buttonStyle(.plain)
                            }
                            .listRowBackground(Color.appSecondaryBackground)
                        }
                        .onDelete(perform: deleteFavorites)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground)
            .navigationTitle(
                isLoggedIn
                ? "\(currentUsername)'s Favorites"
                : "Favorites"
            )
            .navigationBarTitleDisplayMode(.inline)

            .onAppear {
                loadFavorites()
            }

            .onChange(of: currentUsername) {
                loadFavorites()
            }

            .onChange(of: isLoggedIn) {
                loadFavorites()
            }
        }
    }

    // MARK: Load Favorites

    private func loadFavorites() {

        guard isLoggedIn,
              !currentUsername.isEmpty,
              let data = UserDefaults.standard.data(
                forKey: favoritesKey
              ),
              let decoded = try? JSONDecoder().decode(
                [TheMealDB.Meal].self,
                from: data
              )
        else {
            favoriteRecipes = []
            return
        }

        favoriteRecipes = decoded
    }

    // MARK: Remove Favorite

    private func removeFavorite(_ recipe: TheMealDB.Meal) {

        favoriteRecipes.removeAll {
            $0.id == recipe.id
        }

        saveFavorites()
    }

    private func deleteFavorites(at offsets: IndexSet) {

        favoriteRecipes.remove(atOffsets: offsets)
        saveFavorites()
    }

    // MARK: Save Favorites

    private func saveFavorites() {

        guard isLoggedIn,
              !currentUsername.isEmpty
        else {
            return
        }

        if let data = try? JSONEncoder().encode(
            favoriteRecipes
        ) {

            UserDefaults.standard.set(
                data,
                forKey: favoritesKey
            )
        }
    }
}

#Preview {
    FavoritesView()
}
