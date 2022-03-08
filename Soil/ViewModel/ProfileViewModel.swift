//
//  ProfileViewModel.swift
//  Soil
//
//  Created by dykoon on 2021/11/14.
//

import UIKit

struct ProfileViewModel {
  
  let user: User
  
  var uid: String { return user.uid }
  
  var fullname: String { return user.name ?? "" }
  
  var nickname: String { return user.nickname }
  
  var bio: String { return user.bio ?? "" }
  
  var type: Int { return user.type }
  
  var profileImageURL: URL? {
    return URL(string: user.profileImageURL ?? "")
  }

  var numberOfFollowers: NSAttributedString {
    return attributedStatText(label: "팔로워  ", value: user.followers)
  }
  
  var numberOfFollowing: NSAttributedString {
    return attributedStatText(label: "팔로잉  ", value: user.following)
  }
  
  var followButtonText: String {
    switch self.type {
    case 1:
      return "Edit Profile"
    case 2:
      return "Following"
    case 3:
      return "Follow"
    default:
      return "Loading..."
    }
  }
  
  var followButtonBackgroundColor: UIColor {
    switch self.type {
    case 1, 2:
      return .white
    default:
      return .black
    }
  }
  
  var followButtonTextColor: UIColor {
    switch self.type {
    case 1:
      return .systemGray2
    case 2:
      return .black
    default:
      return .white
    }
  }
  
  var fullnameCount: String {
    return "\(fullname.count) / 15"
  }
  
  var bioCount: String {
    return "\(bio.count) / 300"
  }
  
  init(user: User) {
    self.user = user
  }
  
  func attributedStatText(label: String, value: Int) -> NSAttributedString {
    let attributedText = NSMutableAttributedString(
      string: label,
      attributes: [
        .font: UIFont.notoSansKR(size: 13, family: .medium),
        .foregroundColor: UIColor.black
      ]
    )
    attributedText.append(
      NSAttributedString(
        string: "\(value)",
        attributes: [
          .font: UIFont.ceraPro(size: 20, family: .bold),
          .foregroundColor: UIColor.black
        ]
      )
    )
    return attributedText
  }
}
