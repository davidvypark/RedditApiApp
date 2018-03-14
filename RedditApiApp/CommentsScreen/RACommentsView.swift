//
//  RACommentsView.swift
//  RedditApiApp
//
//  Created by David Park on 3/14/18.
//  Copyright © 2018 DavidVY. All rights reserved.
//

import Foundation
import UIKit

private let kTableViewTopPadding: CGFloat = 50

final class RACommentsView: UIView {
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.showsVerticalScrollIndicator = true
    table.separatorStyle = .none
    table.separatorInset = .zero
    table.backgroundColor = .clear
    table.register(RACommentTableViewCell.self,
                   forCellReuseIdentifier: RACommentTableViewCell.description())
    table.delaysContentTouches = true
    return table
  }()
  
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
  
  private func initialize() {
    translatesAutoresizingMaskIntoConstraints = false
    setupTable()
  }
  
  private func setupTable() {
    addSubview(tableView)
    addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal,
                                          toItem: self, attribute: .top, multiplier: 1, constant: kTableViewTopPadding))
    addConstraint(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal,
                                          toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal,
                                          toItem: self, attribute: .left, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal,
                                          toItem: self, attribute: .right, multiplier: 1, constant: 0))
  }
  
  func setDelegateAndDataSource(viewController: UIViewController) {
    tableView.delegate = viewController
    tableView.dataSource = viewController
  }
  
}
