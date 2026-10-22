import SwiftUI

struct AboutUsView: View {

    var body: some View {

        NavigationStack {

            VStack(spacing: 24) {

                Spacer()

                Image(systemName: "film.stack.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.blue)
                    .padding()
                    .background(.orange.opacity(0.15))
                    .clipShape(Circle())

                Text("About Our Movie Portal")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Movie Portal is a CPSC 411 demo application designed to help students explore SwiftUI, navigation, state management, APIs, favorites, visualizations, and other common mobile app development concepts.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 28)

                VStack(spacing: 8) {
                    Text("CPSC 411: Mobile Device Application Development")
                        .font(.headline)
                        .foregroundStyle(.blue)
                        .padding()

                    

                    Text("California State University, Fullerton")
                        .font(.subheadline)

                    Text("Instructor: Duy Ho")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.orange)
                }
                .multilineTextAlignment(.center)

                NavigationLink {
                    HomePageView()
                } label: {
                    HStack {
                        Image(systemName: "film.fill")
                        Text("See Our Movies")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)

                Spacer()
            }
            .navigationTitle("About Us")
        }
    }
}

#Preview {
    AboutUsView()
}

