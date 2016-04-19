//
//  ImageNetworkOperation.swift
//  SwiftWeather
//
//  Created by Mykhailo Vorontsov on 12/04/2016.
//  Copyright © 2016 Mykhailo Vorontsov. All rights reserved.
//

import UIKit

/**
 Operation for loading image from cache or remote location.
 
 Actually is a general kind of operations and can be moved to DataRetrievalKit
 */
class ImageNetworkOperation: CachedNetworkDataRetrievalOperation {
  
  let imagePath:String
  
  init(imagePath:String) {
    self.imagePath = imagePath
    super.init()
  }
  
  override func prepareForRetrieval() {
    cache = true
    // If path contains ':/' then it is a full address,
    // else it is a local address and should by added to endpoint
    if imagePath.containsString(":/") {
      requestEndPoint = imagePath
    } else {
      requestPath = imagePath
    }
    super.prepareForRetrieval()
  }
  
  // Convert and parse data
  override func convertData() {
    stage = .Converting
    guard let data = data,
      let image = UIImage(data: data) else {
        breakWithErrorCode(.NoData)
        return
    }
    stage = .Parsing
    results = [image]
  }
  
  
}
