//
//  MoreInfoViewController.swift
//  AroundFootball
//
//  Created by 강창현 on 2022/05/10.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

class MoreInfoViewController: UIViewController {
    
    var nickname: String?
    var email: String?
    var url: URL?
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var phNumTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var tapNextButton: UIButton!
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var rightFootButton: UIButton!
    @IBOutlet weak var leftFootButton: UIButton!
    @IBOutlet weak var bothFootButton: UIButton!
    
    @IBOutlet weak var fwButton: UIButton!
    @IBOutlet weak var mfButton: UIButton!
    @IBOutlet weak var dfButton: UIButton!
    @IBOutlet weak var gkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        // ✅ NextButton UI 설정
        tapNextButton.layer.borderColor = UIColor.darkGray.cgColor
        tapNextButton.layer.borderWidth = 1
        tapNextButton.layer.cornerRadius = 5
        nameTextField.textColor = .white
        
        
    }
    // ✅ 화면 터치 시 입력창 닫기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func tapGenderButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    @IBAction func tapLikeFootButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    @IBAction func tapPositionButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterViewController") as? EnterViewController else { return }
        
        // ✅ 사용자 정보 넘기기
        nextVC.nickname = nameTextField.text
        nextVC.url = url
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        guard let myInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "MyInfoViewController") as? MyInfoViewController else { return }
        
        myInfoVC.name = nameTextField.text
        myInfoVC.age = ageTextField.text
        myInfoVC.phNum = phNumTextField.text
        myInfoVC.location = locationTextField.text
        //myInfoVC.male = maleButton.title(for: .normal)
        //myInfoVC.female = femaleButton.title(for: .normal)
        if maleButton.isSelected == true {
            myInfoVC.gender = maleButton.title(for: .normal)
        } else {
            myInfoVC.gender = femaleButton.title(for: .normal)
        }
    }
}

// MARK: - Extensions

extension MoreInfoViewController {
    private func setUI() {
        // ✅ 사용자 정보 보여주기
        if let nickname = nickname {
            nameTextField.text = nickname
        }
    }
}
