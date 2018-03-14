//
//  UIFontExtension.swift
//  RedditApiApp
//
//  Created by David Park on 3/13/18.
//  Copyright © 2018 DavidVY. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
  
  class func raBook(_ size: CGFloat) -> UIFont {
    guard let font = UIFont(name: "Avenir-Book", size: size) else {
      return UIFont.systemFont(ofSize: size)
    }
    return font
  }
  
  class func raMedium(_ size: CGFloat) -> UIFont {
    guard let font = UIFont(name: "Avenir-Medium", size: size) else {
      return UIFont.systemFont(ofSize: size)
    }
    return font
  }
  
}
