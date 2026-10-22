import SwiftUI

struct FavoritesView: View {

    @State private var showUnseenOnly = true

    private let favoriteMovies = [
        (title: "Avengers: Doomsday", isSeen: false),
        (title: "Insidious: Into the Further", isSeen: true),
        (title: "Resident Evil", isSeen: false),
        (title: "Zootopia", isSeen: true),
        (title: "Spider-Man: Brand New Day", isSeen: false)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.red)
                    .padding()
                    .background(.red.opacity(0.1))
                    .clipShape(Circle())

                Text("Favorite Movies")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Toggle("Unseen Only", isOn: $showUnseenOnly)
                    .font(.headline)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 24)

                List {
                    ForEach(
                        favoriteMovies.filter { movie in
                            !showUnseenOnly || !movie.isSeen
                        },
                        id: \.title
                    ) { movie in
                        HStack {
                            Image(systemName: movie.isSeen
                                  ? "checkmark.circle.fill"
                                  : "circle")
                                .foregroundStyle(movie.isSeen ? .green : .gray)

                            Text(movie.title)

                            Spacer()

                            Text(movie.isSeen ? "Seen" : "Unseen")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Favorites Screen")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FavoritesView()
}
