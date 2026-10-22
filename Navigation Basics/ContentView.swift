import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // 1. Home Page View (Instructor Provided)
            HomePageView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            // 2. Favorites Page View (Instructor Provided)
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }

            // 3. About Us Page View (Instructor Provided)
            AboutUsView()
                .tabItem {
                    Label("About Us", systemImage: "info.circle.fill")
                }

            // TODO 1: Add LoginView tab item here after creating LoginView.swift
            // Example:
            // LoginView()
            //     .tabItem {
            //         Label("Login", systemImage: "person.fill")
            //     }

            // TODO 2: Add DashboardView tab item here after creating DashboardView.swift
            // Example:
            // DashboardView()
            //     .tabItem {
            //         Label("Dashboard", systemImage: "chart.bar.fill")
            //     }
        }
    }
}

#Preview {
    ContentView()
}
