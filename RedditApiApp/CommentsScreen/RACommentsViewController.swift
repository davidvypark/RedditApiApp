//
//  RACommentsViewController.swift
//  RedditApiApp
//
//  Created by David Park on 3/13/18.
//  Copyright © 2018 DavidVY. All rights reserved.
//

import Foundation
import UIKit

private let kBannerLabelText = "Comments"

private let kTableViewTopPadding: CGFloat = 70
private let kBackButtonLeftPadding: CGFloat = 20
private let kBackButtonTopPadding: CGFloat = 30
private let kBannerTextTopPadding: CGFloat = 30
private let kBackgroundAlpha: CGFloat = 0.9

private let kBannerLabelFontSize: CGFloat = 24
private let kBackButtonFontSize: CGFloat = 12

//MARK: - RACommentsViewController

final class RACommentsViewController: RAViewController {
  
  private let commentsArray: [String]
  
  //MARK: - UIElements
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
  
  private let bannerText: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.numberOfLines = 0
    label.font = .raMedium(kBannerLabelFontSize)
    label.text = kBannerLabelText
    return label
  }()
  
  private let backButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("<< Go back", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    button.titleLabel?.font = .raBook(kBackButtonFontSize)
    return button
  }()
  
  //MARK: - Lifetime
  
  required init(comments: [String]) {
    self.commentsArray = comments
    super.init(nibName: nil, bundle: nil)
  }
  
  convenience init() {
    self.init(comments: [])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    backButton.removeTarget(nil, action: nil, for: .allEvents)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupTable()
    setupBanner()
  }
  
  //MARK: - Private
  
  private func setupTable() {
    view.addSubview(tableView)
    view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal,
                                          toItem: view, attribute: .top, multiplier: 1, constant: kTableViewTopPadding))
    view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal,
                                          toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal,
                                          toItem: view, attribute: .left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal,
                                          toItem: view, attribute: .right, multiplier: 1, constant: 0))
    tableView.delegate = self
    tableView.dataSource = self
    tableView.reloadData()
  }
  
  private func setupBanner() {
    view.addSubview(bannerText)
    view.addSubview(backButton)
    
    backButton.addTarget(self, action: #selector(RACommentsViewController.backButtonPressed), for: .touchUpInside)
    
    //Back Button
    view.addConstraint(NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal,
                                          toItem: view, attribute: .left, multiplier: 1, constant: kBackButtonLeftPadding))
    view.addConstraint(NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal,
                                          toItem: view, attribute: .top, multiplier: 1, constant: kBackButtonTopPadding))
    
    //Banner Text
    view.addConstraint(NSLayoutConstraint(item: bannerText, attribute: .centerX, relatedBy: .equal,
                                          toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: bannerText, attribute: .top, relatedBy: .equal,
                                          toItem: view, attribute: .top, multiplier: 1, constant: kBannerTextTopPadding))
    
    
  }
  
  @objc private dynamic func backButtonPressed() {
    navigationController?.popViewController(animated: true)
  }
  
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension RACommentsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commentsArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RACommentTableViewCell.description(), for: indexPath)
    (cell as? RACommentTableViewCell)?.commentText = commentsArray[indexPath.row]
    return cell
  }
  
}
