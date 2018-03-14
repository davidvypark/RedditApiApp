//
//  RAViewController.swift
//  RedditApiApp
//
//  Created by David Park on 3/13/18.
//  Copyright © 2018 DavidVY. All rights reserved.
//

import Foundation
import UIKit

private let kLogoAlpha: CGFloat = 0.2

class RAViewController: UIViewController {
  
  private let logo: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "reddit-logo")
    imageView.alpha = kLogoAlpha
    return imageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupBackgroundLogo()
  }
  
  private func setupBackgroundLogo() {
    view.addSubview(logo)
    view.addConstraint(NSLayoutConstraint(item: logo, attribute: .top, relatedBy: .equal,
                                          toItem: view, attribute: .top, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: logo, attribute: .bottom, relatedBy: .equal,
                                          toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: logo, attribute: .left, relatedBy: .equal,
                                          toItem: view, attribute: .left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: logo, attribute: .right, relatedBy: .equal,
                                          toItem: view, attribute: .right, multiplier: 1, constant: 0))
  }
  
}
