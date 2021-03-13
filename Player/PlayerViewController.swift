import UIKit
import Foundation
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var playControlButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    // simplePlayer 만들고 프로퍼티 추가
    let simplePlayer = SimplePlayer.shared
    
    var timeObserver: Any?
    var isSeeking: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePlayButton()
        updateTime(time: CMTime.zero)
        
        // timeoberver 구현
        // simpleplayer에서 일정 간격으로 시간을 관찰하는 것을 더하겠다 라는 메서드(addPeriodicTimeObserver)
        timeObserver = simplePlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main) { time in
            self.updateTime(time: time)
        }
    }
    
    // 보이기 직전에 호출
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTintColor()
        updateTrackInfo()
    }
    
    // 사라지기 전에 호출
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 재생 중인 화면을 나가면 음악이 중지
        simplePlayer.pause()
        simplePlayer.replaceCurrentItem(with: nil)
    }
    
    // 드래그를 시작할 때
    @IBAction func beginDrag(_ sender: UISlider) {
        isSeeking = true
    }
    
    // 드래그 끝날때
    @IBAction func endDrag(_ sender: UISlider) {
        isSeeking = false
    }
    
    // 시킹
    // 슬라이더 처음 부분은 0, 마지막 부분은 1
    @IBAction func seek(_ sender: UISlider) {
        guard let currentItem = simplePlayer.currentItem else { return }
        let position = Double(sender.value) // 0 ~ 1 사이에 값이 나옴
        let seconds = currentItem.duration.seconds * position
        let time = CMTime(seconds: seconds, preferredTimescale: 100)
        simplePlayer.seek(to: time)
    }
    
    // 플레이어 버튼 토글
    @IBAction func togglePlayButton(_ sender: UIButton) {
        if simplePlayer.isPlaying {
            simplePlayer.pause()
        } else {
            simplePlayer.play()
        }
        updatePlayButton()
    }
}

// 해당하는 받은 곡을 갖고 정보를 업데이트
extension PlayerViewController {
    
    // 트랙 정보 업데이트
    func updateTrackInfo() {
        guard let track = simplePlayer.currentItem?.convertToTrack() else { return }
        thumbnailImageView.image = track.artwork
        titleLabel.text = track.title
        artistLabel.text = track.artist
    }
    
    // 다크 모드 관련
    func updateTintColor() {
        playControlButton.tintColor = DefaultStyle.Colors.tint
        timeSlider.tintColor = DefaultStyle.Colors.tint
    }
    
    func updateTime(time: CMTime) {
        // 시간 정보 업데이트
        currentTimeLabel.text = secondsToString(sec: simplePlayer.currentTime)
        totalDurationLabel.text = secondsToString(sec: simplePlayer.totalDurationTime)
        
        // 슬라이더 정보 업데이트
        if isSeeking == false {
            timeSlider.value = Float(simplePlayer.currentTime/simplePlayer.totalDurationTime)
        }
    }
    
    func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00:00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
    
    // play 버튼 ui작업
    // 토글 버튼을 누를때마다 아이콘 이미지 변경
    func updatePlayButton() {
        // 플레이 중이면 일시 정지로 변경
        if simplePlayer.isPlaying {
            let configuration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
            // 플레이 중이 아니면 플레이로 변경
        } else {
            let configuration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "play.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        }
    }
}
