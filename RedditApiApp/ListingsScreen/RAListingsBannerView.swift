//
//  RAListingsBannerView.swift
//  RedditApiApp
//
//  Created by David Park on 3/14/18.
//  Copyright © 2018 DavidVY. All rights reserved.
//

import UIKit

private let kHotButtonTitle = "HOT"
private let kTopButtonTitle = "TOP"
private let kNewButtonTitle = "NEW"

private let kSelfCornerRadius: CGFloat = 10
private let kButtonAlpha: CGFloat = 0.5

private let kButtonFontSize: CGFloat = 13

// MARK: - Helper
private func roundButtonWith(title: String) -> UIButton {
  let button = UIButton()
  button.translatesAutoresizingMaskIntoConstraints = false
  button.setTitle(title, for: .normal)
  button.titleLabel?.font = .raMedium(kButtonFontSize)
  button.backgroundColor = UIColor.lightGray.withAlphaComponent(kButtonAlpha)
  button.setTitleColor(.black, for: .normal)
  button.setTitleColor(.blue, for: .highlighted)
  button.setTitleColor(.white, for: .selected)
  return button
}

//MARK: - RAListingsBannerViewDelegate

protocol RAListingsBannerViewDelegate: AnyObject {
  func listingsBannerView(_ view: RAListingsBannerView, didPressButtonTitle title: String)
}

//MARK: - RAListingsBannerView

class RAListingsBannerView: UIView {
  
  weak var delegate: RAListingsBannerViewDelegate?
  
  private let hotButton = roundButtonWith(title: kHotButtonTitle)
  private let topButton = roundButtonWith(title: kTopButtonTitle)
  private let newButton = roundButtonWith(title: kNewButtonTitle)
  
  init() {
    super.init(frame: .zero)
    initialize()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  deinit {
    hotButton.removeTarget(nil, action: nil, for: .allEvents)
    topButton.removeTarget(nil, action: nil, for: .allEvents)
    newButton.removeTarget(nil, action: nil, for: .allEvents)
  }
  
  private func initialize() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = kSelfCornerRadius
    clipsToBounds = true
    hotButton.isSelected = true
    
    addSubview(hotButton)
    addSubview(topButton)
    addSubview(newButton)
    
    hotButton.addTarget(self, action: #selector(RAListingsBannerView.buttonPressed(_:)), for: .touchUpInside)
    topButton.addTarget(self, action: #selector(RAListingsBannerView.buttonPressed(_:)), for: .touchUpInside)
    newButton.addTarget(self, action: #selector(RAListingsBannerView.buttonPressed(_:)), for: .touchUpInside)
    
    //Hot Button
    addConstraint(NSLayoutConstraint(item: hotButton, attribute: .top, relatedBy: .equal, toItem: self,
                                     attribute: .top, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: hotButton, attribute: .bottom, relatedBy: .equal, toItem: self,
                                     attribute: .bottom, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: hotButton, attribute: .left, relatedBy: .equal, toItem: self,
                                     attribute: .left, multiplier: 1, constant: 0))
    
    //Top Button
    addConstraint(NSLayoutConstraint(item: topButton, attribute: .top, relatedBy: .equal, toItem: self,
                                     attribute: .top, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: topButton, attribute: .bottom, relatedBy: .equal, toItem: self,
                                     attribute: .bottom, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: topButton, attribute: .left, relatedBy: .equal, toItem: hotButton,
                                     attribute: .right, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: topButton, attribute: .width, relatedBy: .equal, toItem: hotButton,
                                     attribute: .width, multiplier: 1, constant: 0))
    
    //New Button
    addConstraint(NSLayoutConstraint(item: newButton, attribute: .top, relatedBy: .equal, toItem: self,
                                     attribute: .top, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: newButton, attribute: .bottom, relatedBy: .equal, toItem: self,
                                     attribute: .bottom, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: newButton, attribute: .left, relatedBy: .equal, toItem: topButton,
                                     attribute: .right, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: newButton, attribute: .width, relatedBy: .equal, toItem: topButton,
                                     attribute: .width, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: newButton, attribute: .right, relatedBy: .equal, toItem: self,
                                     attribute: .right, multiplier: 1, constant: 0))
    
  }
  
  @objc private dynamic func buttonPressed(_ button: UIButton) {
    
    hotButton.isSelected = false
    topButton.isSelected = false
    newButton.isSelected = false
    button.isSelected = true
    
    guard let title = button.titleLabel?.text else {
      return
    }
    delegate?.listingsBannerView(self, didPressButtonTitle: title)
  }
  
}
