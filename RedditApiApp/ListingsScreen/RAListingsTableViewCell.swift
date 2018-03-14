//
//  RAListingsTableViewCell.swift
//  RedditApiApp
//
//  Created by David Park on 3/13/18.
//  Copyright © 2018 DavidVY. All rights reserved.
//

import Foundation
import UIKit

private let kEmptyImageLabelText = "preview\nunavailable"

private let kThumbnailEdgePadding: CGFloat = 20
private let kThumbnailDimension: CGFloat = 70
private let kTitleLabelLeftPadding: CGFloat = 20
private let kTitleLabelRightPadding: CGFloat = 20
private let kTitleVerticalPadding: CGFloat = 35
private let kBoxVerticalMargin: CGFloat = 5
private let kBoxHorizontalMargin: CGFloat = 10
private let kBoxCornerRadius: CGFloat = 5
private let kBoxAlpha: CGFloat = 0.95
private let kThumbnailAlpha: CGFloat = 0.3
private let kBoxBorderWidth: CGFloat = 1
private let kBorderAlpha: CGFloat = 0.2

private let kTitleLabelFontSize: CGFloat = 18
private let kEmptyLabelFontSize: CGFloat = 10

//MARK: - RAListingsTableViewCell

final class RAListingsTableViewCell: UITableViewCell {
  
  var viewModel: RAFeedListingItem? {
    didSet {
      guard let vm = viewModel else {
        return
      }
      titleLabel.text = vm.title
      RAURLFetcher.download(url: vm.thumbnailImageURL, to: thumbnail)
    }
  }
  
  private let box: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.white.withAlphaComponent(kBoxAlpha)
    view.clipsToBounds = true
    view.layer.cornerRadius = kBoxCornerRadius
    view.layer.borderColor = UIColor.blue.withAlphaComponent(kBorderAlpha).cgColor
    view.layer.borderWidth = kBoxBorderWidth
    return view
  }()
  
  private let thumbnail: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(kThumbnailAlpha)
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = kThumbnailDimension / 2
    return imageView
  }()
  
  private let emptyImageLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.numberOfLines = 0
    label.text = kEmptyImageLabelText
    label.font = .raBook(kEmptyLabelFontSize)
    return label
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .left
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.font = .raMedium(kTitleLabelFontSize)
    return label
  }()
  
  // MARK: - Lifetime
  
  init(frame: CGRect) {
    super.init(style: .default, reuseIdentifier: nil)
    initialize()
  }
  
  required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialize()
  }
  
  init() {
    super.init(style: .default, reuseIdentifier: nil)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  //MARK: - Private
  
  private func initialize() {
    selectionStyle = .none
    backgroundColor = .clear
    
    contentView.addSubview(box)
    contentView.addSubview(emptyImageLabel)
    contentView.addSubview(thumbnail)
    contentView.addSubview(titleLabel)
    
    //Box
    addConstraint(NSLayoutConstraint(item: box, attribute: .bottom, relatedBy: .equal,
                                     toItem: self, attribute: .bottom, multiplier: 1, constant: -kBoxVerticalMargin))
    addConstraint(NSLayoutConstraint(item: box, attribute: .top, relatedBy: .equal,
                                     toItem: self, attribute: .top, multiplier: 1, constant: kBoxVerticalMargin))
    addConstraint(NSLayoutConstraint(item: box, attribute: .right, relatedBy: .equal,
                                     toItem: self, attribute: .right, multiplier: 1, constant: -kBoxHorizontalMargin))
    addConstraint(NSLayoutConstraint(item: box, attribute: .left, relatedBy: .equal,
                                     toItem: self, attribute: .left, multiplier: 1, constant: kBoxHorizontalMargin))
    
    //Empty Image Label
    addConstraint(NSLayoutConstraint(item: emptyImageLabel, attribute: .centerX, relatedBy: .equal,
                                     toItem: thumbnail, attribute: .centerX, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: emptyImageLabel, attribute: .centerY, relatedBy: .equal,
                                     toItem: thumbnail, attribute: .centerY, multiplier: 1, constant: 0))
    
    //Thumbnail
    addConstraint(NSLayoutConstraint(item: thumbnail, attribute: .left, relatedBy: .equal,
                                     toItem: self, attribute: .left, multiplier: 1, constant: kThumbnailEdgePadding))
    addConstraint(NSLayoutConstraint(item: thumbnail, attribute: .centerY, relatedBy: .equal,
                                     toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: thumbnail, attribute: .height, relatedBy: .equal,
                                     toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: kThumbnailDimension))
    addConstraint(NSLayoutConstraint(item: thumbnail, attribute: .width, relatedBy: .equal,
                                     toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: kThumbnailDimension))

    //Title Label
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal,
                                     toItem: self, attribute: .right, multiplier: 1, constant: -kTitleLabelRightPadding))
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal,
                                     toItem: thumbnail, attribute: .right, multiplier: 1, constant: kTitleLabelLeftPadding))
    
    //ContentView Sizing
    let marginGuide = contentView.layoutMarginsGuide
    titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -kTitleVerticalPadding).isActive = true
    titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: kTitleVerticalPadding).isActive = true
  }
  
}
