import SwiftUI

struct SearchView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Search")
                .font(.title)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

#Preview {
    SearchView()
} 