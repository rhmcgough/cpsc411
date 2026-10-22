import SwiftUI

struct HomePageView: View {
    
    @State private var showLatestMovies = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.blue, .orange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(0.8)
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    
                    Text("Movie Portal")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    
                    Text("Welcome to CPSC-411!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Image(systemName: "hand.wave")
                        .font(.system(size: 72))
                        .foregroundStyle(.white)
                        .padding()
                        .background(.black.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text("Featured Movie Title")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 16) {
                        Text("Action")
                        Text("Comedy")
                        Text("Drama")
                        Text("Sci-Fi")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    
                    Text("Discover featured movies, explore different genres, and find something new to watch.")
                        .font(.body)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button {
                        withAnimation {
                            showLatestMovies.toggle()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "film")
                            Text(showLatestMovies
                                 ? "Hide Latest Movies"
                                 : "View Latest Movies")
                        }
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.black.opacity(0.75))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 40)
                    
                    if showLatestMovies {
                        VStack(spacing: 8) {
                            Text("Latest Movies")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            VStack(spacing: 8) {
                                Text("Avengers: Doomsday")
                                Text("Resident Evil")
                                Text("Insidious: Into the Further")
                            }
                                
                        }
                        .padding()
                        .background(.black.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .transition(.opacity.combined(with: .scale))
                    }
                }
                .padding()
                .offset(y: -40)
            }
            .navigationTitle("Welcome Screen")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomePageView()
}
