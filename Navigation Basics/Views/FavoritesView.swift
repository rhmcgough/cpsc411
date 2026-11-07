import SwiftUI

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let genre: String
    let imageName: String

    // TODO:
    // Add year, rating, director, and localVideoName.
}

struct FavoritesView: View {

    @State private var selectedMovie: Movie?

    // TODO:
    // After adding the new Movie properties,
    // update each movie below with:
    // year, rating, director, and localVideoName.

    private let movies = [
        Movie(
            title: "Avengers: Doomsday",
            genre: "Action / Sci-Fi",
            imageName: "avengers_doomsday"
        ),
        Movie(
            title: "Minions",
            genre: "Animation / Comedy",
            imageName: "minions"
        ),
        Movie(
            title: "Obsession",
            genre: "Thriller / Drama",
            imageName: "obsession"
        ),
        Movie(
            title: "Resident Evil",
            genre: "Horror / Action",
            imageName: "resident_evil"
        ),
        Movie(
            title: "Spider-Man: Brand New Day",
            genre: "Action / Superhero",
            imageName: "spiderman_brand_new_day"
        ),
        Movie(
            title: "Zootopia 2",
            genre: "Animation / Family",
            imageName: "zootopia_2"
        )
    ]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(0.8)
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Title, top left
                    Text("Saved")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // Movie grid (always visible)
                    VStack(alignment: .leading, spacing: 16) {

                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(movies) { movie in
                                Button {
                                    selectedMovie = movie
                                } label: {
                                    VStack(spacing: 8) {
                                        Image(movie.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 180)
                                            .clipShape(
                                                RoundedRectangle(cornerRadius: 10)
                                            )

                                        Text(movie.title)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                            .lineLimit(1)
                                    }
                                    .padding(8)
                                    .background(.black.opacity(0.35))
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 14)
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                }
                .padding(.vertical)
            }
        }
        .sheet(item: $selectedMovie, content: { movie in
            MovieDetailSheet(
                movie: movie,
                dismiss: {
                    selectedMovie = nil
                }
            )
        })
    }
}

struct MovieDetailSheet: View {

    let movie: Movie
    let dismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {

            Image(movie.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(movie.title)
                .font(.title2)
                .fontWeight(.bold)

            Text(movie.genre)
                .foregroundStyle(.secondary)

            // TODO:
            // Display year, rating, and director here.

            // TODO:
            // Add local video playback here.

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
}

#Preview {
    FavoritesView()
}
