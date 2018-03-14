//
//  RAListingsViewController.swift
//  RedditApiApp
//
//  Created by David Park on 3/13/18.
//  Copyright © 2018 DavidVY. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

//MARK: - RAListingsViewController

final class RAListingsViewController: RAViewController {
  
  private var feedListingsArray: [RAFeedListingItem] = []
  
  private let backendService = RABackendService()
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.showsVerticalScrollIndicator = true
    table.separatorStyle = .none
    table.separatorInset = .zero
    table.backgroundColor = .clear
    table.register(RAListingsTableViewCell.self,
                   forCellReuseIdentifier: RAListingsTableViewCell.description())
    table.delaysContentTouches = true
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    fetchAndUpdateData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
  //MARK: - Private
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    view.addSubview(tableView)
    view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal,
                                          toItem: view, attribute: .top, multiplier: 1, constant: 50))
    view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal,
                                          toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal,
                                          toItem: view, attribute: .left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal,
                                          toItem: view, attribute: .right, multiplier: 1, constant: 0))
    
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  private func fetchAndUpdateData() {
    firstly {
      backendService.fetchFeedListings()
      }.done { [weak self] result in
        
        result.forEach({ (item) in
          guard let feedItem = RAFeedListingItem(dict: item as [String : AnyObject]) else {
            return
          }
          self?.feedListingsArray.append(feedItem)
        })
        self?.tableView.reloadData()
      }.catch { error in
        print(error)
    }
  }
  
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension RAListingsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return feedListingsArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RAListingsTableViewCell.description(), for: indexPath)
    (cell as? RAListingsTableViewCell)?.viewModel = feedListingsArray[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var comments: [String] = []
    let cell = tableView.cellForRow(at: indexPath) as? RAListingsTableViewCell
    guard let model = cell?.viewModel else {
      return
    }
    
    //TODO: Add Activity Indicator
    firstly {
      backendService.fetchComments(subreddit: model.subreddit, article: model.article)
      }.done { [weak self] result in
        result.forEach({ (item) in
          if let data = item["data"] as? RAAnyObjectDictionary,
             let body = data["body"] as? String {
            comments.append(body)
          }
        })
        let vc = RACommentsViewController(comments: comments)
        self?.navigationController?.pushViewController(vc, animated: true)
      }.catch { error in
        print(error)
      }
  }
  
}
