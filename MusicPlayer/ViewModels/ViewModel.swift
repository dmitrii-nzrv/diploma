//
//  ViewModel.swift
//  MusicPlayer
//
//  Created by Dmitrii Nazarov on 02.06.2025.
//

import Foundation
import AVFAudio
import AVFoundation

class ViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    // MARK: ~ Properties
    @Published var songs: [SongModel] = []
    @Published var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentIndex: Int?
    @Published var currentTime: TimeInterval = 0.0
    @Published var totalTime: TimeInterval = 0.0
    
    
    
    var currentSong: SongModel? {
        guard let currentIndex = currentIndex, songs.indices.contains(currentIndex) else { return nil }
        return songs[currentIndex]
    }
    
    // MARK: ~ Playlists for sections
    var topOfTheDaySongs: [SongModel] {
        Array(songs.prefix(2))
    }
    var popularSongs: [SongModel] {
        Array(songs.dropFirst(2).prefix(3))
    }
    var chillSongs: [SongModel] {
        // Просто беру каждый второй трек
        songs.enumerated().compactMap { $0.offset % 2 == 0 ? $0.element : nil }
    }
    var workoutSongs: [SongModel] {
        // Просто беру каждый третий трек
        songs.enumerated().compactMap { $0.offset % 3 == 0 ? $0.element : nil }
    }
    
    // MARK: ~ Methods
    override init() {
        super.init()
        setupAudioSession()
        loadSongsFromResources()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    private func loadSongsFromResources() {
        if let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) {
            for url in urls {
                do {
                    let data = try Data(contentsOf: url)
                    let asset = AVAsset(url: url)
                    var song = SongModel(name: url.lastPathComponent, data: data)
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
                    if !self.songs.contains(where: { $0.name == song.name }) {
                        self.songs.append(song)
                    }
                } catch {
                    print("Error loading song from resources: \(error)")
                }
            }
        }
    }
    
    func playAudio(song: SongModel) {
        do {
            // Останавливаем текущее воспроизведение
            stopAudio()
            
            // Создаем новый плеер
            self.audioPlayer = try AVAudioPlayer(data: song.data)
            self.audioPlayer?.delegate = self
            self.audioPlayer?.prepareToPlay()
            
            // Проверяем, что аудио-сессия активна
            if !AVAudioSession.sharedInstance().isOtherAudioPlaying {
                try AVAudioSession.sharedInstance().setActive(true)
            }
            
            // Начинаем воспроизведение
            if self.audioPlayer?.play() == true {
                isPlaying = true
                totalTime = audioPlayer?.duration ?? 0.0
                if let index = songs.firstIndex(where: { $0.id == song.id }) {
                    currentIndex = index
                }
                // Добавляем в историю
                HistoryManager.shared.addToHistory(song)
            } else {
                print("Failed to play audio")
                isPlaying = false
            }
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
            isPlaying = false
        }
    }
    
    func forward() {
        guard let currentIndex = currentIndex else { return }
        let nextIndex = currentIndex + 1 < songs.count ? currentIndex + 1 : 0
        playAudio(song: songs[nextIndex])
    }
    
    func backward() {
        guard let currentIndex = currentIndex else { return }
        let previusIndext = currentIndex > 0 ? currentIndex - 1 : songs.count - 1
        playAudio(song: songs[previusIndext])
    }
    
    func durationFormatted(_ duration: Double) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func playPause() {
        if isPlaying {
            audioPlayer?.pause()
            isPlaying = false
        } else {
            if audioPlayer?.play() == true {
                isPlaying = true
            }
        }
    }
    
    func seekAudio(time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        currentTime = 0.0
        totalTime = 0.0
    }
    
    func updateProgress() {
        guard let player = audioPlayer else { return }
        currentTime = player.currentTime
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            forward()
        }
    }
    
    func delete(offsets: IndexSet) {
        if let first = offsets.first {
            stopAudio()
            songs.remove(at: first)
        }
    }
    
    deinit {
        stopAudio()
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
