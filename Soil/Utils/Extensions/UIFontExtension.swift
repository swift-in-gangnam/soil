//
//  UIFontExtension.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/03.
//

import Foundation
import UIKit

extension UIFont {
    
    enum Family: String {
        case black = "Black"
        case bold = "Bold"
        case semiBold = "SemiBold"
        case light = "Light"
        case medium = "Medium"
        case regular = "Regular"
        case thin = "Thin"
    }
    
    /// Family: 전체 다 지원
    static func montserrat(size: CGFloat = 10, family: Family = .regular) -> UIFont {
        return UIFont(name: "Montserrat-\(family)", size: size)!
    }
    
    /// Family: .Black, .Bold, .Light, .Medium만 지원
    static func ceraPro(size: CGFloat = 10, family: Family = .medium) -> UIFont {
        return UIFont(name: "CeraPro-\(family)", size: size)!
    }
    
    /// Family: .SemiBold 빼고 지원
    static func notoSansKR(size: CGFloat = 10, family: Family = .medium) -> UIFont {
        return UIFont(name: "NotoSansKR-\(family)", size: size)!
    }
}
