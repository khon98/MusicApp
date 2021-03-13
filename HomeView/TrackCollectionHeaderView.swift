import UIKit
import AVFoundation

class TrackCollectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var item: AVPlayerItem?
    var tapHandler: ((AVPlayerItem) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 4
    }
    
    func update(with item: AVPlayerItem) {
        // 헤더 뷰 업데이트
        self.item = item
        guard let track = item.convertToTrack() else { return }
        
        self.thumbnailImageView.image = track.artwork
        self.descriptionLabel.text = "Today's pick is \(track.artist)'s album - \(track.albumName)"
    }
    
    // 이미지에 있는 버튼 클릭 했을 때
    @IBAction func cardTapped(_ sender: Any) {
        guard let todaysItem = item else { return }
        tapHandler?(todaysItem)
    }
}
