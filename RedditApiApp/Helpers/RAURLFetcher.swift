//
//  RAURLFetcher.swift
//  RedditApiApp
//
//  Created by David Park on 3/13/18.
//  Copyright © 2018 DavidVY. All rights reserved.
//

import Foundation
import UIKit

final class RAURLFetcher {
  
  class func download(url: URL, to imageView: UIImageView) {
    let session = URLSession(configuration: .default)
    let downloadTask = session.dataTask(with: url) { (data, response, error) in
      if let e = error {
        print("ERROR: \(e)")
        DispatchQueue.main.async {
          imageView.image = nil
        }
      } else {
        if nil != (response as? HTTPURLResponse) {
          if let imageData = data {
            DispatchQueue.main.async {
              imageView.image = UIImage(data: imageData)
            }
          } else {
            print("ERROR: Image is nil")
          }
        } else {
          print("ERROR: Unknown response")
        }
      }
    }
    downloadTask.resume()
  }
  
}
