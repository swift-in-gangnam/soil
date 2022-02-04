//
//  ViewController.swift
//  soilTest
//
//  Created by 임영선 on 2021/11/08.
//

import UIKit
import Then
import SnapKit

class LoginHomeController: UIViewController {

  // MARK: - Properties
  private let logoImageView = UIImageView().then {
    $0.image = UIImage(named: "SoilIcon")
    $0.contentMode = .scaleAspectFit
    $0.alpha = 0.0
  }
  
  private let chineseLabel = UILabel().then {
    $0.text = "‘消日’"
    $0.textColor = .lightGray
    $0.alpha = 0.0
    $0.textAlignment = .center
    $0.font = UIFont.notoSansKR(size: 50, family: .regular)
  }
  
  private let soilExplanationLabel = UILabel().then {
    $0.text = "어떠한 것에 재미를 붙여     \n   심심하지 아니하게 세월을 보냄."
    $0.textColor = .black
    $0.numberOfLines = 0
    $0.alpha = 0.0
    $0.textAlignment = .left
    $0.font = UIFont.notoSansKR(size: 25, family: .thin)
  }
  
  private lazy var signUpButton = UIButton().then {
    $0.backgroundColor = .black
    $0.setTitle("회원가입", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont.notoSansKR(size: 17, family: .bold)
    $0.layer.cornerRadius = 15
    $0.alpha = 1.0
    $0.snp.makeConstraints { make in
      make.height.equalTo(50)
    }
    $0.addTarget(self, action: #selector(didTabSignUpButton), for: .touchUpInside)
  }
  
  private lazy var signInButton = UIButton().then {
    let title = "이미 계정이 있어요"
    $0.setTitle(title, for: .normal)
    $0.titleLabel?.font = UIFont.notoSansKR(size: 15, family: .regular)
    $0.setTitleColor(.black, for: .normal)
    let attributedString = NSMutableAttributedString(string: title)
    attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue,
                                  range: NSRange(location: 0, length: title.count))
    $0.setAttributedTitle(attributedString, for: .normal) // title에 밑줄 추가
    $0.addTarget(self, action: #selector(didTabSignInButton), for: .touchUpInside)
  }
    
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(named: "E5E5E5")
    layoutSubviews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animate()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
    navigationController?.navigationBar.tintColor = .black
    setTransparentNavigationBar()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  // MARK: - Methods
  @objc func didTabSignUpButton() {
    let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
    let vc = storyboard.instantiateViewController(withIdentifier: "emailInputVC")
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc func didTabSignInButton() {
    let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
    let vc = storyboard.instantiateViewController(withIdentifier: "loginVC")
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func layoutSubviews() {
    view.addSubview(logoImageView)
    logoImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(80)
    }
    
    view.addSubview(chineseLabel)
    chineseLabel.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(385)
      make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(38)
    }
    
    view.addSubview(soilExplanationLabel)
    soilExplanationLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(453)
    }
    
    view.addSubview(signUpButton)
    signUpButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(32)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-32)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-50)
    }
    
    view.addSubview(signInButton)
    signInButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(signUpButton.snp.bottom).offset(3)
    }
  }
  
  func animate() {
    UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) {
      self.logoImageView.alpha = 1.0
      self.logoImageView.snp.updateConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(34)
      }
      self.view.layoutIfNeeded()
    }.startAnimation()
    
    UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) {
      self.chineseLabel.alpha = 1.0
      self.chineseLabel.snp.updateConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(215)
      }
      self.view.layoutIfNeeded()
    }.startAnimation(afterDelay: 0.2)

    UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) {
      self.soilExplanationLabel.alpha = 1.0
      self.soilExplanationLabel.snp.updateConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(303)
      }
      self.view.layoutIfNeeded()
    }.startAnimation(afterDelay: 0.4)
  }
  
  // 네비게이션바 투명하게 처리
  func setTransparentNavigationBar() {
    let bar: UINavigationBar! =  self.navigationController?.navigationBar
    bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    bar.shadowImage = UIImage()
    bar.backgroundColor = UIColor.clear
  }

}
