//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Dmitrii Nazarov on 30.05.2025.
//

import SwiftUI
import FirebaseAuth

struct BrowseView: View {
    // MARK: ~ Properties
    @StateObject var vm = ViewModel()
    @State private var showFiles = false
    @State private var showFullPlayer = false
    @Namespace var playAnimation
    
    
    var frameImage: CGFloat {
        showFullPlayer ? 320 : 50
    }
    
    
    // MARK: ~ Body
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                List {
                    // Top of the Day
                    if !vm.topOfTheDaySongs.isEmpty {
                        Text("Top of the Day")
                            .foregroundColor(.white)
                            .font(.headline)
                            .listRowBackground(Color.clear)
                        ForEach(vm.topOfTheDaySongs) { song in
                            SongCell(song: song, durationFormatted: vm.durationFormatted)
                                .onTapGesture { vm.playAudio(song: song) }
                        }
                    }
                    // Popular
                    if !vm.popularSongs.isEmpty {
                        Text("Popular")
                            .foregroundColor(.white)
                            .font(.headline)
                            .listRowBackground(Color.clear)
                        ForEach(vm.popularSongs) { song in
                            SongCell(song: song, durationFormatted: vm.durationFormatted)
                                .onTapGesture { vm.playAudio(song: song) }
                        }
                    }
                    // Chill
                    if !vm.chillSongs.isEmpty {
                        Text("Chill")
                            .foregroundColor(.white)
                            .font(.headline)
                            .listRowBackground(Color.clear)
                        ForEach(vm.chillSongs) { song in
                            SongCell(song: song, durationFormatted: vm.durationFormatted)
                                .onTapGesture { vm.playAudio(song: song) }
                        }
                    }
                    // Workout
                    if !vm.workoutSongs.isEmpty {
                        Text("Workout")
                            .foregroundColor(.white)
                            .font(.headline)
                            .listRowBackground(Color.clear)
                        ForEach(vm.workoutSongs) { song in
                            SongCell(song: song, durationFormatted: vm.durationFormatted)
                                .onTapGesture { vm.playAudio(song: song) }
                        }
                    }
                }
                .listStyle(.plain)
                Spacer()
                if vm.currentSong != nil {
                    Player()
                        .frame(height: showFullPlayer ? SizeConstant.fullPlayer : SizeConstant.miniPlayer)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                self.showFullPlayer.toggle()
                            }
                        }
                }
            }
        }
    }
    
    // MARK: ~ Methods
    @ViewBuilder
    private func Player() -> some View {
        VStack {
            
            /// Mini player
            HStack {
                // image cover
                SongImageView(imageData: vm.currentSong?.coverImage, size: frameImage)
                
                if !showFullPlayer {
                    VStack(alignment: .leading) {
                        SongDescription()
                    }
                    .matchedGeometryEffect(id: "Description", in: playAnimation)
                    
                    Spacer()
                    
                    CustomButton(image: vm.isPlaying ? "pause.fill" : "play.fill", size: .title) {
                        vm.playPause()
                    }
                    
                    
                }
                
                
            }
            .padding()
            .background(showFullPlayer ? .clear : .black.opacity(0.3))
            .cornerRadius(10)
            //.padding()
            .padding(.top, -10)
            
            /// Full player
            if showFullPlayer {
                VStack{
                    SongDescription()
                }
                .matchedGeometryEffect(id: "Description", in: playAnimation)
                .padding(.top)
                
                VStack{
                    /// duration
                    HStack{
                        Text("\(vm.durationFormatted(vm.currentTime))")
                        Spacer()
                        Text("\(vm.durationFormatted(vm.totalTime))")
                    }
                    .durationFont()
                    .padding()
                    
                    /// slider
                    Slider(value: $vm.currentTime, in:  0...vm.totalTime) { editing in
                        if !editing {
                            vm.seekAudio(time: vm.currentTime)
                        }
                    }
                    .offset(y: -18)
                    .tint(.white)
                    .onAppear() {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            vm.updateProgress()
                        }
                    }
                    
                    HStack(spacing: 40) {
                        CustomButton(image: "backward.end.fill", size: .title2) {
                            vm.backward()
                        }
                        CustomButton(image: vm.isPlaying ? "pause.circle.fill" : "play.circle.fill" , size: .largeTitle) {
                            vm.playPause()
                        }
                        CustomButton(image: "forward.end.fill", size: .title2) {
                            vm.forward()
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
        }
    }
    
    private func CustomButton(image: String, size: Font, action: @escaping () ->()) -> some View{
        Button {
            action()
        } label: {
            Image(systemName: image)
                .foregroundStyle(.white)
                .font(size)
        }

    }
    
    @ViewBuilder
    private func SongDescription() -> some View {
        if let currentSong = vm.currentSong {
            Text(currentSong.name)
                .nameFont()
            Text(currentSong.artist ?? "unknown artist")
                .artistFont()
        }
    }
    
}

#Preview {
    BrowseView()
}



