//
//  RABackendService.swift
//  RedditApiApp
//
//  Created by David Park on 3/13/18.
//  Copyright © 2018 DavidVY. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import PromiseKit

typealias RAAnyObjectDictionary = [String: Any]

final class RABackendService {
  
  func fetchFeedListings(_ param: String) -> Promise<[RAAnyObjectDictionary]> {

    return Promise { seal in

      Alamofire.request("http://www.reddit.com/r/all/\(param).json")
        .responseJSON { response in
          if let json = response.result.value as? [String: AnyObject],
             let data = json["data"],
             let children = data["children"],
             let feedItems = children as? [[String: AnyObject]] {

            seal.fulfill(feedItems)
          } else {
            if let error = response.error {
              seal.reject(error)
            }
          }
      }
    }

  }
  
  func fetchComments(subreddit: String, article: String) -> Promise<[RAAnyObjectDictionary]> {
    return Promise { seal in
      Alamofire.request("http://reddit.com/r/\(subreddit)/comments/\(article).json")
        .responseJSON { response in
          if let json = response.result.value as? [AnyObject],
             let comments = json[1] as? RAAnyObjectDictionary,
             let data = comments["data"] as? RAAnyObjectDictionary,
             let children = data["children"] as? [RAAnyObjectDictionary] {
            seal.fulfill(children)
          } else {
            if let error = response.error {
              seal.reject(error)
            }
          }
      }
    }
  }
  
}
