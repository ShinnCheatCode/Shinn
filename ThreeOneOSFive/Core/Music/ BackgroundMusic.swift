import Foundation
import AVFoundation

final class BackgroundMusic {
    static let shared = BackgroundMusic()
    private var player: AVPlayer?
    private let session = AVAudioSession.sharedInstance()

    func start() {
        configureSession()
        guard let url = musicURL() else { return }
        player = AVPlayer(url: url)
        player?.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self,
            selector: #selector(loop),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem)
        player?.play()
    }
    func stop() { player?.pause(); player = nil }
    private func configureSession() {
        try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try? session.setActive(true)
    }
    @objc private func loop() {
        player?.seek(to: .zero); player?.play()
    }
    private func musicURL() -> URL? {
        Bundle.main.url(forResource: "background_music", withExtension: "mp3")
    }
}