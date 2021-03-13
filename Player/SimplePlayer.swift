import AVFoundation

class SimplePlayer {
    // 싱글톤
    static let shared = SimplePlayer()
    
    private let player = AVPlayer()
    
    // currnettime 구하기
    var currentTime: Double {
        return player.currentItem?.currentTime().seconds ?? 0
    }
    
    // totaldurationtime 구하기
    var totalDurationTime: Double {
        return player.currentItem?.duration.seconds ?? 0
    }
    
    // 현재 플레이어가 재생 중인지 아닌지 확인
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    // 현재 플레이어에서 재생되고 있는 아이템
    var currentItem: AVPlayerItem? {
        return player.currentItem
    }
    
    init() { }
    
    // pause 구현
    func pause() {
        player.pause()
    }
    
    // play 구현
    func play() {
        player.play()
    }
    
    // seek 구현 / 해당 하는 시간에 맞게 avplayer가 seeking 해줌
    func seek(to time:CMTime) {
        player.seek(to: time)
    }
    
    // replacecurrnetitem 구현
    func replaceCurrentItem(with item: AVPlayerItem?) {
        player.replaceCurrentItem(with: item)
    }
    
    func addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) {
        player.addPeriodicTimeObserver(forInterval: forInterval, queue: queue, using: using)
    }
}
