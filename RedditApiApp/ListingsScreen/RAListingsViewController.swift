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

private let kBannerHeight: CGFloat = 70
private let kStatusBarHeight: CGFloat = 20
private let kBannerSidePadding: CGFloat = 10

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
  
  private let bannerView = RAListingsBannerView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    setupBanner()
    fetchAndUpdateData(param: "hot")
  }
  
  override func viewDidAppear(_ animated: Bool) {
//    tableView.reloadData()
  }
  
  //MARK: - Private
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    view.addSubview(tableView)
    view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal,
                                          toItem: view, attribute: .top, multiplier: 1, constant: kBannerHeight))
    view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal,
                                          toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal,
                                          toItem: view, attribute: .left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal,
                                          toItem: view, attribute: .right, multiplier: 1, constant: 0))
    
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  private func setupBanner() {
    bannerView.delegate = self
    view.addSubview(bannerView)
    view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .top, relatedBy: .equal,
                                          toItem: view, attribute: .top, multiplier: 1, constant: kStatusBarHeight))
    view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .bottom, relatedBy: .equal,
                                          toItem: tableView, attribute: .top, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .left, relatedBy: .equal,
                                          toItem: view, attribute: .left, multiplier: 1, constant: kBannerSidePadding))
    view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .right, relatedBy: .equal,
                                          toItem: view, attribute: .right, multiplier: 1, constant: -kBannerSidePadding))
  }
  
  private func fetchAndUpdateData(param: String) {
    firstly {
      backendService.fetchFeedListings(param)
      }.done { [weak self] result in
        self?.feedListingsArray.removeAll()
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

//MARK: - RAListingsBannerViewDelegate

extension RAListingsViewController: RAListingsBannerViewDelegate {
  
  func listingsBannerView(_ view: RAListingsBannerView, didPressButtonTitle title: String) {
    feedListingsArray.removeAll()
    tableView.reloadData()
    fetchAndUpdateData(param: title.lowercased())
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
    tableView.isUserInteractionEnabled = false
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
        tableView.isUserInteractionEnabled = true
      }.catch { error in
        tableView.isUserInteractionEnabled = true
        print(error)
      }
  }
  
}
