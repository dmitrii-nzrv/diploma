//
//  SongCell.swift
//  MusicPlayer
//
//  Created by Dmitrii Nazarov on 30.05.2025.
//

import SwiftUI

struct SongCell: View {
    // MARK: ~ Properties
    let song: SongModel
    let durationFormatted: (TimeInterval) -> String
    
    // MARK: ~ Body
    var body: some View {
        HStack{
            SongImageView(imageData: song.coverImage, size: 60)
            
            VStack(alignment: .leading){
                Text(song.name)
                    .nameFont()
                Text(song.artist ?? "Unknown artist")
                    .artistFont()
            }
            
            Spacer()
            
            if let duration = song.duration{
                Text(durationFormatted(duration))
                    .artistFont()
            }
            
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}


