import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // 1. Home Page View (Instructor Provided)
            HomePageView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            // 3. About Us Page View (Instructor Provided)
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            CreateView()
                 .tabItem {
                     Label("Create", systemImage: "plus.circle.fill")
                 }



            // 2. Favorites Page View (Instructor Provided)
            FavoritesView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark.fill")
                }

            
            
            
            SettingsView()
                 .tabItem {
                     Label("Settings", systemImage: "gearshape.fill")
                 }
        }
    }
}

#Preview {
    ContentView()
}
