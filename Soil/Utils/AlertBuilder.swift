//
//  AlertBuilder.swift
//  Soil
//
//  Created by Dongyoung Kwon on 2022/09/17.
//

import UIKit

/// `UIAlertController`를 쉽게 사용하고자 *Builder* 패턴을 적용한 Class
///
///     AlertBuilder(viewController: self)
///         .title("test")
///         .message("message")
///         .preferredStyle(.alert)
///         .onDefaultAction(title: "default") {
///             print("did tap dafault action button")
///         }
///         .onDestructiveAction(title: "destructive") {
///             print("did tap dafault destructive button")
///         }
///         .onCancelAction(title: "cancel") {
///             print("did tap cancel action button")
///         }
///         .onAction(.init(title: "action", style: .default, handler: { _ in
///             print("did tap action")
///         }))
///         .show()
///
/// - Important: Alert에 필요한 것을 메서드를 조립 후, 마지막에는 ``show()`` 메서드를 추가해야 합니다.
///
final class AlertBuilder {
  private let viewController: UIViewController
  private var alertTitle: String?
  private var alertMessage: String?
  private var alertStyle: UIAlertController.Style = .alert
  private var alertActions: [UIAlertAction] = []
  
  init(viewController: UIViewController) {
    self.viewController = viewController
  }
  
  /// Alert의 title
  func title(_ title: String?) -> Self {
    alertTitle = title
    return self
  }
  
  /// Alert의 message
  func message(_ message: String?) -> Self {
    alertMessage = message
    return self
  }
  
  /// Alert를 보여줄 때 사용할 style
  ///
  /// - Important: `iPad`에서는 `.actionSheet` 사용 불가
  func preferredStyle(_ style: UIAlertController.Style) -> Self {
    alertStyle = UIDevice.current.userInterfaceIdiom == .pad ? .alert : style
    return self
  }
  
  /// 완성된 `UIAlertAction`를 추가할 때 사용
  func onAction(_ action: UIAlertAction) -> Self {
    alertActions.append(action)
    return self
  }

  /// `default` 스타일을 가진 `action` 생성
  ///
  /// - Parameters:
  ///   - title: button에 사용할 텍스트
  ///   - completion: 유저가 `action`을 선택할 때 실행할 블록
  func onDefaultAction(title: String, completion: (() -> Void)? = nil) -> Self {
    alertActions.append(.init(title: title, style: .default, handler: { _ in completion?() }))
    return self
  }
  
  /// `cancel` 스타일을 가진 `action` 생성
  ///
  /// - Parameters:
  ///   - title: button에 사용할 텍스트
  ///   - completion: 유저가 `action`을 선택할 때 실행할 블록
  func onCancelAction(title: String, completion: (() -> Void)? = nil) -> Self {
    alertActions.append(.init(title: title, style: .cancel, handler: { _ in completion?() }))
    return self
  }
  
  /// `destructive` 스타일을 가진 `action` 생성
  ///
  /// - Parameters:
  ///   - title: button에 사용할 텍스트
  ///   - completion: 유저가 `action`을 선택할 때 실행할 블록
  func onDestructiveAction(title: String, completion: (() -> Void)? = nil) -> Self {
    alertActions.append(.init(title: title, style: .destructive, handler: { _ in completion?() }))
    return self
  }
  
  /// 조립된 메소드를 바탕으로 `Alert`를 띄움
  func show() {
    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: alertStyle)
    alertActions.forEach { alertController.addAction($0) }
    viewController.present(alertController, animated: true, completion: nil)
  }
}
