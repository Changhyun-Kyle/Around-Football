//
//  EnterViewController.swift
//  AroundFootball
//
//  Created by 강창현 on 2022/03/23.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

class EnterViewController: UIViewController {
    
    var nickname: String?
    var email: String?
    var url: URL?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var kickOffButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.sizeToFit()
        setUI()
        
        kickOffButton.layer.cornerRadius = 5
        
        // ✅ 프로필 이미지 UI
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = UIColor.darkGray.cgColor
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
}
// MARK: - Extensions

extension EnterViewController {
    private func setUI() {
        // ✅ 사용자 정보 보여주기
        if let nickname = nickname {
            nameLabel.text = """
                                환영합니다
                                \(nickname) 님!
                             """
        }
        if let data = try? Data(contentsOf: url!){
            self.profileImageView?.image = UIImage(data: data)
        }
        
    }
}
