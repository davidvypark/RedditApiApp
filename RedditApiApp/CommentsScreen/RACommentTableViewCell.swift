//
//  RACommentTableViewCell.swift
//  RedditApiApp
//
//  Created by David Park on 3/13/18.
//  Copyright © 2018 DavidVY. All rights reserved.
//

import Foundation
import UIKit

private let kCommentLabelVerticalPadding: CGFloat = 20
private let kCommentLabelHorizontalPadding: CGFloat = 20
private let kLineWidthRatio: CGFloat = 0.3
private let kBackgroundAlpha: CGFloat = 0.9
private let kLineHeight: CGFloat = 1
private let kCommentLabelFontSize: CGFloat = 14

class RACommentTableViewCell: UITableViewCell {
  
  var commentText: String = "" {
    didSet {
      commentLabel.text = commentText
    }
  }
  
  private let commentLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .left
    label.lineBreakMode = .byWordWrapping
    label.font = .raBook(kCommentLabelFontSize)
    label.numberOfLines = 0
    return label
  }()
  
  private let line: UIView = {
    let line = UIView()
    line.translatesAutoresizingMaskIntoConstraints = false
    line.backgroundColor = .lightGray
    return line
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
    backgroundColor = UIColor.white.withAlphaComponent(kBackgroundAlpha)
    selectionStyle = .none
    
    contentView.addSubview(commentLabel)
    contentView.addSubview(line)
    
    //Line
    addConstraint(NSLayoutConstraint(item: line, attribute: .bottom, relatedBy: .equal,
                                     toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: line, attribute: .centerX, relatedBy: .equal,
                                     toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: line, attribute: .width, relatedBy: .equal,
                                     toItem: self, attribute: .width, multiplier: kLineWidthRatio, constant: 0))
    addConstraint(NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal,
                                     toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: kLineHeight))
    
    //Comment Label
    let marginGuide = contentView.layoutMarginsGuide
    commentLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -kCommentLabelVerticalPadding).isActive = true
    commentLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: kCommentLabelVerticalPadding).isActive = true
    commentLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: kCommentLabelHorizontalPadding).isActive = true
    commentLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: -kCommentLabelHorizontalPadding).isActive = true
    
    
  }
  
}
