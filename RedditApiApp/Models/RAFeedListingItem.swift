//
//  RAFeedListingItem.swift
//  RedditApiApp
//
//  Created by David Park on 3/13/18.
//  Copyright © 2018 DavidVY. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

//MARK: - RYAFeedListingItem

final class RAFeedListingItem {
  
  let subreddit: String
  let article: String
  let thumbnailImageURL: URL
  let title: String
  
  init?(dict: [String: AnyObject]) {
      
    if let details = dict["data"],
       let imageUrlString = details["thumbnail"] as? String,
       let itemTitle = details["title"] as? String,
       let imageUrl = URL(string: imageUrlString),
       let subreddit = details["subreddit"] as? String,
       let article = details["id"] as? String {
      self.thumbnailImageURL = imageUrl as URL
      self.title = itemTitle
      self.subreddit = subreddit
      self.article = article
    } else {
      return nil
    }
  }

}
