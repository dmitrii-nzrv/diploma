//
//  ImportFileManager.swift
//  MusicPlayer
//
//  Created by Dmitrii Nazarov on 02.06.2025.
//

import Foundation
import SwiftUI
import AVFoundation

struct ImportFileManager: UIViewControllerRepresentable {
    
    @Binding var songs: [SongModel]
    // координатор управляет задачи между swiftui и uikit
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    //
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .open)
        
        picker.allowsMultipleSelection = false
        picker.shouldShowFileExtensions = true
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate{
        
        // ссылка на родительский компонент ImportFileManager, чтобы можно было с ним взаимодействовать
        var parent: ImportFileManager
        
        init(parent: ImportFileManager) {
            self.parent = parent
        }
        
        // вызывается когда пользователь выбирает документ (песню)
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
            
            defer{url.stopAccessingSecurityScopedResource()}
            
            do {
                let document = try Data(contentsOf: url)
                
                let asset = AVAsset(url: url)
                
                var song = SongModel(name: url.lastPathComponent, data: document)
                
                let metadata = asset.metadata
                for item in metadata {
                    
                    guard let key = item.commonKey?.rawValue, let value = item.value else { continue }
                    switch key {
                    case AVMetadataKey.commonKeyArtist.rawValue:
                        song.artist = value as? String
                    case AVMetadataKey.commonKeyArtwork.rawValue:
                        song.coverImage = value as? Data
                    case AVMetadataKey.commonKeyTitle.rawValue:
                        song.name = value as? String ?? song.name
                    default:
                        break
                    }
                    
                }
                song.duration = CMTimeGetSeconds(asset.duration)
                
                if !self.parent.songs.contains(where: { $0.name == song.name }) {
                    DispatchQueue.main.async {
                        self.parent.songs.append(song)
                    }
                } else {
                    print("the song already exists")
                }
                
            } catch {
                print("Error processing the file \(error)")
            }
        }
    }
}
