//
//  FontsView.swift
//  MusicPlayer
//
//  Created by Dmitrii Nazarov on 30.05.2025.
//

import SwiftUI

// приминимо к структурам 
struct DurationFontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.system(size: 14, weight: .light, design: .rounded))
    }
}

extension View {
    func durationFont() -> some View {
        self.modifier(DurationFontModifier())
    }
}
// приминимо только к вьюшке
extension Text {
    func nameFont() -> some View{
        self
            .foregroundStyle(.white)
            .font(.system(size: 16, weight: .semibold, design: .rounded))
    }
    
    func artistFont() -> some View{
        self
            .foregroundStyle(.white)
            .font(.system(size: 14, weight: .light, design: .rounded))
    }
}



struct FontsView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .nameFont()
        }
    }
}

#Preview {
    FontsView()
}
