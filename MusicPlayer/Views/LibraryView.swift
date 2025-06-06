import SwiftUI

struct LibraryView: View {
    @StateObject var vm = ViewModel()
    @State private var userSongs: [SongModel] = []
    @State private var showFiles = false
    @State private var showFullPlayer = false
    @Namespace var playAnimation
    
    var frameImage: CGFloat {
        showFullPlayer ? 320 : 50
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack {
                    List {
                        ForEach(userSongs) { song in
                            SongCell(song: song, durationFormatted: vm.durationFormatted)
                                .onTapGesture {
                                    vm.songs = userSongs
                                    vm.playAudio(song: song)
                                }
                        }
                        .onDelete(perform: delete)
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFiles.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                }
            }
            .sheet(isPresented: $showFiles) {
                ImportFileManager(songs: $userSongs)
            }
        }
        .onAppear {
            vm.songs = userSongs
        }
        .onChange(of: userSongs) { newValue in
            vm.songs = newValue
        }
    }
    
    private func delete(at offsets: IndexSet) {
        userSongs.remove(atOffsets: offsets)
        if let current = vm.currentSong, !userSongs.contains(where: { $0.id == current.id }) {
            vm.stopAudio()
        }
    }
    
    @ViewBuilder
    private func Player() -> some View {
        VStack {
            HStack {
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
            .padding(.top, -10)
            if showFullPlayer {
                VStack{
                    SongDescription()
                }
                .matchedGeometryEffect(id: "Description", in: playAnimation)
                .padding(.top)
                VStack{
                    HStack{
                        Text("\(vm.durationFormatted(vm.currentTime))")
                        Spacer()
                        Text("\(vm.durationFormatted(vm.totalTime))")
                    }
                    .durationFont()
                    .padding()
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
    LibraryView()
} 