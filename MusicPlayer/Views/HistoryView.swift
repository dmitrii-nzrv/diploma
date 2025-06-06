import SwiftUI

class HistoryManager: ObservableObject {
    static let shared = HistoryManager()
    @Published var history: [SongModel] = []
    private init() {
        // Захардкоженные треки из ресурсов
        if let url1 = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)?.first,
           let data1 = try? Data(contentsOf: url1) {
            let song1 = SongModel(name: url1.lastPathComponent, data: data1)
            history.append(song1)
        }
        if let url2 = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)?.dropFirst().first,
           let data2 = try? Data(contentsOf: url2) {
            let song2 = SongModel(name: url2.lastPathComponent, data: data2)
            history.append(song2)
        }
    }
    func addToHistory(_ song: SongModel) {
        // Удаляем если уже есть, чтобы не было дублей
        history.removeAll { $0.id == song.id }
        history.insert(song, at: 0) // Последний прослушанный — первый
        // Оставляем только последние 30
        if history.count > 30 { history = Array(history.prefix(30)) }
    }
}

struct HistoryView: View {
    @ObservedObject var historyManager = HistoryManager.shared
    @StateObject var vm = ViewModel()
    @State private var showFullPlayer = false
    @Namespace var playAnimation
    
    var frameImage: CGFloat {
        showFullPlayer ? 320 : 50
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                if historyManager.history.isEmpty {
                    Spacer()
                    Image(systemName: "clock.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No listening history yet")
                        .font(.title)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        Text("Recently Played")
                            .foregroundColor(.white)
                            .font(.headline)
                            .listRowBackground(Color.clear)
                        ForEach(historyManager.history) { song in
                            SongCell(song: song, durationFormatted: vm.durationFormatted)
                                .onTapGesture {
                                    vm.playAudio(song: song)
                                }
                        }
                    }
                    .listStyle(.plain)
                }
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
    HistoryView()
} 