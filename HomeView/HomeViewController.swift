import UIKit

class HomeViewController: UIViewController {
    let trackManger: TrackManager = TrackManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Data source
extension HomeViewController: UICollectionViewDataSource {
  
    // 뷰를 몇개 표시 할지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 트랙 매니져에서 트랙 개수 가져오기
        return trackManger.tracks.count
    }
    
    // 셀을 어떻게 표시할지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 셀 구성
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionViewCell", for: indexPath) as? TrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let track = trackManger.track(at: indexPath.item)
        cell.updateUI(item: track)
        return cell
    }
    
    // 헤더 뷰는 어떻게 표시할지
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        // 헤더 구성
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let item = trackManger.todaysTrack else {
                return UICollectionReusableView()
            }
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackCollectionHeaderView", for: indexPath) as? TrackCollectionHeaderView else {
                return UICollectionReusableView()
            }
            
            // 헤더 뷰에 설정된 곡 정보가 탭 할 때 내려오고
            header.update(with: item)
            header.tapHandler = { item -> Void in
                // 그걸 이용해서 playervc를 띄움
                let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
                guard let playerVC = playerStoryboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else { return }
                playerVC.simplePlayer.replaceCurrentItem(with: item)
                self.present(playerVC, animated: true, completion: nil)
                 
                print("\(item.convertToTrack()?.title)")
            }
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

// Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    // 클릭했을때 어떻게 표현할지
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 곡 클릭시 플레이어뷰 띄우기
        let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
        guard let playerVC = playerStoryboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else { return }
        
        // 곡 전달
        let item = trackManger.tracks[indexPath.item]
        playerVC.simplePlayer.replaceCurrentItem(with: item)
        present(playerVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    // 셀 사이즈는 어떻게 할건지
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 셀 사이즈 구하기
        let itemSpacing: CGFloat = 20
        let margin: CGFloat = 20
        let width = (collectionView.bounds.width - itemSpacing - margin * 2)/2
        let height = width + 60
        return CGSize(width: width, height: height)
    }
}
