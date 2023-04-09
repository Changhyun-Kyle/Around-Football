//
//  MainViewController.swift
//  AroundFootball
//
//  Created by 강창현 on 2022/03/23.
//

import UIKit
import NMapsMap
import CoreLocation
import FirebaseDatabase

class MainViewController: UIViewController {
    var ref: DatabaseReference!             //Firebase Realtime Database Reference
    var playgroundList: [PlaygroundList] = []
    var locationManager = CLLocationManager()
    let markerDetailViewController = MarkerDetailViewController(contentViewController: UITableViewController())
    
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var switchButton: UISwitch!
    
    var mapView: NMFMapView {
        return naverMapView.mapView
    }
    
    @objc func buttonTapped() {
        let bottomSheetVC = MarkerDetailViewController(contentViewController: UITableViewController())
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.addSubview(searchBar)
        self.mapView.addSubview(switchButton)
        
        /* 현재 위치, 줌 확대, 축소 버튼 활성화 */
        naverMapView.showLocationButton = true

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        /* 마커 클릭 이벤트 생성 */
        mapView.touchDelegate = self
        let sdkBundle = Bundle.naverMapFramework()

        /*현 위치로 카메라 이동*/
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
    
        // ✅ SearchBar Custom Style 설정
        searchBar.attributedPlaceholder = NSAttributedString(string: "장소를 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])

        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 5
        searchBar.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        searchBar.layer.masksToBounds = false
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 1, height: 2)
        searchBar.layer.shadowOpacity = 0.07
        searchBar.layer.shadowRadius = 1.5
        
        // ✅ Firebase Realtime Database load
        ref = Database.database().reference()
        ref.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else { return }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let markerData = try JSONDecoder().decode([String: PlaygroundList].self, from: jsonData)
                let playgroundLists = Array(markerData.values)
                self.playgroundList = playgroundLists

            } catch let error {
                print("ERROR JSON parsing \(error.localizedDescription)")
            }
        }
        
        // ✅ 마커 표시
        let marker1 = NMFMarker()
        marker1.position = NMGLatLng(lat: 37.591407, lng: 127.024937)
        marker1.captionText = "고려대학교 녹지운동장"
        marker1.touchHandler = { (overlay) in
            if let marker = overlay as? NMFMarker {
                if marker.iconImage.reuseIdentifier == "\(sdkBundle.bundleIdentifier ?? "").mSNormal" {
                    marker.iconImage = NMFOverlayImage(name: "mSNormalNight", in: Bundle.naverMapFramework())
                    print("Marker Tapped")
                    let markerDetailVC = MarkerDetailViewController(contentViewController: ContentViewController())
                    markerDetailVC.modalPresentationStyle = .overFullScreen
                    self.present(markerDetailVC, animated: false, completion: nil)
                } else {
                    marker.iconImage = NMFOverlayImage(name: "mSNormal", in: Bundle.naverMapFramework())
                    print("Marker Removed")
                }
            }
            return true
        }

        marker1.mapView = mapView
        
        let marker2 = NMFMarker()
        marker2.position = NMGLatLng(lat: 37.5264488, lng: 127.1199714)
        marker2.captionText = "성내유수지 축구장"
        marker2.mapView = mapView
        
        let marker3 = NMFMarker()
        marker3.position = NMGLatLng(lat: 37.5243901, lng: 127.118536)
        marker3.captionText = "송파구 여성축구장"
        marker3.mapView = mapView
        
        let marker4 = NMFMarker()
        marker4.position = NMGLatLng(lat: 37.4968788, lng: 127.099293)
        marker4.captionText = "탄천유수지"
        marker4.mapView = mapView
        
        let marker5 = NMFMarker()
        marker5.position = NMGLatLng(lat: 37.50036, lng: 127.1601091)
        marker5.captionText = "천마공원축구장"
        marker5.mapView = mapView
        
        let marker6 = NMFMarker()
        marker6.position = NMGLatLng(lat: 37.5023158, lng: 127.1534019)
        marker6.captionText = "천마풋살파크"
        marker6.mapView = mapView
        
        let marker7 = NMFMarker()
        marker7.position = NMGLatLng(lat: 37.5106481, lng: 127.1460234)
        marker7.captionText = "천마풋살아레나"
        marker7.mapView = mapView
        
        let marker8 = NMFMarker()
        marker8.position = NMGLatLng(lat: 37.5288539, lng: 126.9640447)
        marker8.captionText = "아디다스 더 베이스 서울"
        marker8.mapView = mapView
        
        let marker9 = NMFMarker()
        marker9.position = NMGLatLng(lat: 37.6085014, lng: 127.0405197)
        marker9.captionText = "월곡 인조잔디 축구장"
        marker9.mapView = mapView
        
        let marker10 = NMFMarker()
        marker10.position = NMGLatLng(lat: 37.503412, lng: 127.0775794)
        marker10.captionText = "잠실어울림 축구장"
        marker10.mapView = mapView
        
        let marker11 = NMFMarker()
        marker11.position = NMGLatLng(lat: 37.5050439, lng: 127.0677125)
        marker11.captionText = "대치유수지 체육공원"
        marker11.mapView = mapView
        
        let marker12 = NMFMarker()
        marker12.position = NMGLatLng(lat: 37.5743984, lng: 127.0901063)
        marker12.captionText = "용마폭포공원 축구장"
        marker12.mapView = mapView
    }
    
    // ✅ 화면 터치 시 입력창 닫기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension MainViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation() // 중요!
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("GPS 권한 요청 거부됨")
        default:
            print("GPS: Default")
        }
    }
}

extension MainViewController: NMFMapViewTouchDelegate {
//    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//       let markerDetailViewController = MarkerDetailViewController
//       present(alertController, animated: true) {
//           DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 0.5), execute: {
//               alertController.dismiss(animated: true, completion: nil)
//           })
//       }
//   }
}
