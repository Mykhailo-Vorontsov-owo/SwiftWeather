//
//  GeosearchDataOperation.swift
//  SwiftWeather
//
//  Created by Mykhailo Vorontsov on 11/04/2016.
//  Copyright © 2016 Mykhailo Vorontsov. All rights reserved.
//

import Foundation
import DataRetrievalKit
import CoreData
import CoreLocation

/**
 Operation for searching new location. Apple has no designated suggestion service yet.
 Better to use Google API (iOS SDK, or WebService).
 I've decided not to use it here as it is 3-rd party and SDK keys required, and to save time.
 */
class GeosearchDataOperation: DataRetrievalOperation, ManagedObjectRetrievalOperationProtocol {

  var dataManager: CoreDataManager!
  
  lazy var geocoder = {
    return CLGeocoder()
  }()
  
  let requestAddress: String
  
  init(request:String) {
    requestAddress = request
    super.init()
  }
  
  override  func retriveData() throws {
    try super.retriveData()
    let semaphore:DispatchSemaphore = DispatchSemaphore(value: 0);
    
    geocoder.geocodeAddressString(requestAddress, in: nil) { ( placemarks, error) -> Void in
      
      self.error = error
      self.convertedObject = placemarks as AnyObject
      
      semaphore.signal()
    }
    _ = semaphore.wait(timeout: DispatchTime.distantFuture)
  }
  
  override func parseData() throws {
    try super.parseData()
    
    guard let convertedObject = convertedObject as? [CLPlacemark] else {
      throw DataRetrievalOperationError.internalError(error: nil)
    }
    
    let context = dataManager.dataContext
    var parsedObjects = [NSManagedObjectID]()
    context.performAndWait { 
      if let allResults =  SearchResult.allObjects(context) {
        context.deleteObjects(allResults)
      }
      
      for placemark in convertedObject {
        let result = SearchResult(managedContext: context)!
        parsedObjects.append(result.objectID)
        guard let name = placemark.name,
        let country = placemark.country else {
          continue
        }
        result.string =  "\(name), \(country )"
      }
      
    }
    context.save(recursive:true)
    results = parsedObjects
  }
  
  override func cancel() {
    geocoder.cancelGeocode()
    super.cancel()
  }
  
}
