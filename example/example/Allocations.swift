//
//  Allocations.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import DynamicJSON

public class Allocations {
  let allocations: String
  let audience : Audience = Audience()
  
  init (allocations: String) {
    self.allocations = allocations
  }
  
  func getMyType<T>(_ element: T) -> Any? {
    return type(of: element)
  }
  

  typealias JsonElement = Any
  
  // func getValueFromAllocations<T>(key: String, type: T, participant: AscendParticipant) throws -> T {

  
  func getValueFromAllocations<T>(key: String, type: T, participant: AscendParticipant) throws -> Dictionary<String,Any> {

    let data = allocations.data(using: .utf8)!
    var keyParts = [String]()
    var allocation = [String: Any]()
    do {
      if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String,Any>] {
        keyParts = key.components(separatedBy: "\\.")
        if (keyParts.isEmpty()) { throw AscendKeyError(rawValue: "Key provided was empty.")! }
        
        // iterate through the array of json
        // convert each item into a json object
        // check to see if there is an audience filter
        // if not... traverse the genome object and get the value at each key part
        // return new jsonObj with the element and type
        
        for a in jsonArray {
          allocation = a
          print("Iterating through the array \(a)")

        }
        
      } else {
        let keyPartsStr = keyParts.map{ String($0) }
        let eid = allocation["eid"]
        Log.logger.log(.debug, message: "Unable to find key \(keyPartsStr) in experiement \(String(describing: eid))")
      }
    } catch let error {
      Log.logger.log(.debug, message: "Key provided was empty.")
      return ["":""]
    }
    return  ["":""]
  }
  
  func getElementFromGenome(genome: Any, keyParts: [String]) throws -> Any {
    var element: JsonElement? = genome
    if element == nil { // is this a safe check?
      throw AscendKeyError(rawValue: "Allocation genome was empty")!
    }
    for part: String in keyParts {
      // convert element to json object
      let object = element as! [String:Any]
      element = object[part]
    }
    return element
  }
}
