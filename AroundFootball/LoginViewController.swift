//
//  LoginViewController.swift
//  AroundFootball
//
//  Created by 강창현 on 2022/03/23.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

class LoginViewController: UIViewController {
    
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kakaoLoginButton.layer.cornerRadius = 5
        appleLoginButton.layer.cornerRadius = 5
        appleLoginButton.layer.borderWidth = 1
        appleLoginButton.layer.borderColor = UIColor.darkGray.cgColor
        
        setUI()
        setGestureRecognizer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // ✅ 유효한 토큰 검사
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                                //로그인 필요
                            } else {
                                //기타 에러
                            }
                        } else {
                            //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                            
                            // ✅ 사용자 정보를 가져오고 화면전환을 하는 커스텀 메서드
                            self.getUserInfo()
                            }
                    }
            } else {
                    //로그인 필요
        }
    }
}
// MARK: - Extensions

extension LoginViewController {

    // MARK: - Methods

    private func setUI() {

        // ✅ 카카오 로그인 이미지 설정
        kakaoLoginButton.contentMode = .scaleAspectFit
        kakaoLoginButton.image = UIImage(named: "kakao_login_large_wide")

//        loginWithKakaoaccountImageView.contentMode = .scaleAspectFit
//        loginWithKakaoaccountImageView.image = UIImage(named: "kakao_login_large_wide")

        self.navigationController?.navigationBar.isHidden = true
    }

    // ✅ 이미지뷰에 제스쳐 추가
    private func setGestureRecognizer() {
        let loginKakao = UITapGestureRecognizer(target: self, action: #selector(loginKakao))
        kakaoLoginButton.isUserInteractionEnabled = true
        kakaoLoginButton.addGestureRecognizer(loginKakao)

//        let loginKakaoAccount = UITapGestureRecognizer(target: self, action: #selector(loginKakaoAccount))
//        loginWithKakaoaccountImageView.isUserInteractionEnabled = true
//        loginWithKakaoaccountImageView.addGestureRecognizer(loginKakaoAccount)
    }

    private func getUserInfo() {
        // ✅ 사용자 정보 가져오기
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")

                // ✅ 사용자정보를 성공적으로 가져오면 화면전환 한다.
                let nickname = user?.kakaoAccount?.profile?.nickname
                let url = user?.kakaoAccount?.profile?.profileImageUrl
                //let email = user?.kakaoAccount?.email
                
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterViewController") as? EnterViewController else { return }
                
                // ✅ 사용자 정보 넘기기
                nextVC.nickname = nickname
                nextVC.url = url
                
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }

    // MARK: - @objc Methods

    // ✅ 카카오로그인 이미지에 UITapGestureRecognizer 를 등록할 때 사용할 @objc 메서드.
    // ✅ 카카오톡으로 로그인
    @objc
    func loginKakao() {
        print("loginKakao() called.")
        
        // ✅ 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    // ✅ 회원가입 성공 시 oauthToken 저장
//                    let kakoOauthToken = oauthToken
//                    UserDefaults.standard.set(kakoOauthToken, forKey: "KakoOauthToken")
                    
                    // ✅ 사용자정보를 성공적으로 가져오면 화면전환 한다.
                    self.getUserInfo()
                }
            }
        }
        // ✅ 카카오톡 미설치
        else {
            print("카카오톡 미설치")
        }
    }

    // ✅ 카카오로그인 이미지에 UITapGestureRecognizer 를 등록할 때 사용할 @objc 메서드.
    // ✅ 카카오계정으로 로그인
    @objc
    func loginKakaoAccount() {
        print("loginKakaoAccount() called.")

        // ✅ 기본 웹 브라우저를 사용하여 로그인 진행.
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")

                // ✅ 회원가입 성공 시 oauthToken 저장
//                 _ = oauthToken

                // ✅ 사용자정보를 성공적으로 가져오면 화면전환 한다.
                self.getUserInfo()
            }
        }
    }
}
