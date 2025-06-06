//
//  SongImageView.swift
//  MusicPlayer
//
//  Created by Dmitrii Nazarov on 04.06.2025.
//

import SwiftUI

struct SongImageView: View {
    // MARK: ~ Properties
    let imageData : Data?
    let size: CGFloat
    
    // MARK: ~ Body
    var body: some View {
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            ZStack{
                Color.gray
                    .frame(width: size, height: size)
                Image(systemName: "music.note")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: size/2)
                    .foregroundStyle(.white)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        
    }
}
