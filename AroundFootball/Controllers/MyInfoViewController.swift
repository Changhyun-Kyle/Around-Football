//
//  MyInfoViewController.swift
//  AroundFootball
//
//  Created by 강창현 on 2022/04/28.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

class MyInfoViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var phNumLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var likeFootLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet var sectionStackViews: [UIStackView]!
    
    var name: String?
    var age: String?
    var phNum: String?
    var location: String?
    var gender: String?
//    var male: String?
//    var female: String?
    var likeFoot: String?
    var posistion: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
}

// MARK: - Extensions

extension MyInfoViewController {
    private func setUI() {
        // ✅ 사용자 정보 보여주기
        if let name = name {
            nameLabel.text = name
            nameLabel.textColor = .white
        }
        if let age = age {
            ageLabel.text = age
            ageLabel.textColor = .white
        }
        if let phNum = phNum {
            phNumLabel.text = phNum
            phNumLabel.textColor = .white
        }
        if let gender = gender {
            genderLabel.text = gender
            genderLabel.textColor = .white
        }
//        if let female = female {
//            genderLabel.text = female
//            genderLabel.textColor = .white
//        }
        if let location = location {
            locationLabel.text = location
        }
        if let likeFootLabel = likeFootLabel {
            likeFootLabel.text = "오른발"
        }
        if let positionLabel = positionLabel {
            positionLabel.text = "FW"
        }
    }
}
