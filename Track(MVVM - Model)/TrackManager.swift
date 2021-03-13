import UIKit
import AVFoundation

// 정의해야 할 프로퍼티 - 트랙, 앨범, 오늘의 곡
class TrackManager {
    
    var tracks: [AVPlayerItem] = []
    var albums: [Album] = []
    var todaysTrack: AVPlayerItem?
    
    // 생성자 정의
    init() {
        let tracks = loadTrack()
        self.tracks = tracks
        self.albums = loadAlbums(tracks: tracks)
        self.todaysTrack = self.tracks.randomElement()
    }
    
    // 트랙 로드
    func loadTrack() -> [AVPlayerItem] {
        
        // Music 폴더에 있는 Mp3 파일들 불러오기
        let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) ?? []
        let items = urls.map { url in
            return AVPlayerItem(url: url)
        }
        return items
    }
    
    // 인덱스에 맞는 트랙 로드
    func track(at index: Int) -> Track? {
        let playerItem = tracks[index]
        let track = playerItem.convertToTrack()
        return track
    }
    
    // 앨범 로딩 메서드 구현
    func loadAlbums(tracks: [AVPlayerItem]) -> [Album] {
        let trackList: [Track] = tracks.compactMap { $0.convertToTrack() }
        let albumDics = Dictionary(grouping: trackList, by: {(track) in track.albumName})
        var albums: [Album] = []
        for (key, value) in albumDics {
            let title = key
            let tracks = value
            let album = Album(title: title, tracks: tracks)
            albums.append(album)
        }
        return albums
    }
    
    // 오늘의 트랙 랜덤으로 선택
    func loadOtherTodaysTrack() {
        self.todaysTrack = self.tracks.randomElement()
    }
}
