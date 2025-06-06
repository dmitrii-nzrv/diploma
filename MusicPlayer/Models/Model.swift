//
//  Model.swift
//  MusicPlayer
//
//  Created by Dmitrii Nazarov on 30.05.2025.
//

import Foundation

struct SongModel: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var data: Data
    var artist: String?
    var coverImage: Data?
    var duration: TimeInterval?
    
    static func == (lhs: SongModel, rhs: SongModel) -> Bool {
        lhs.id == rhs.id
    }
}


