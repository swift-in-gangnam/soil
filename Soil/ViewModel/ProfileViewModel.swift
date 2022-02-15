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
    if user.isCurrentUser {
      return "Edit Profile"
    }
    
    return "Follow"
  }
  
  var followButtonBackgroundColor: UIColor {
    return user.isCurrentUser ? .white : .black
  }
  
  var followButtonTextColor: UIColor {
    return user.isCurrentUser ? .systemGray2 : .white
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
