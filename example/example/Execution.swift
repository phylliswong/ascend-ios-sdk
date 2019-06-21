//
//  Execution.swift
//  example
//
//  Created by phyllis.wong on 6/19/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import DynamicJSON


protocol AscendAction {
  /**
   * Applies a given value to a set of instructions.
   * @param value any value that was requested
   */
  func apply<T>(value: T) -> Void
}

struct Set<Element> where Element : Hashable {}

class Execution {
  
  private let key: String
  private let defaultValue: Any // Generic
  private let function: AscendAction
  private let participant: AscendParticipant
  
  private var alreadyExecuted: Set<String> = Set()
  
  init(key: String, defaultValue: Any,
       function: AscendAction,
       participant: AscendParticipant) {
    self.key = key
    self.defaultValue = defaultValue
    self.function = function
    self.participant = participant
  }
  
  func getKey() -> String { return key }
  
  func getMyType<T>(_ element: T) -> Any? {
    return type(of: element)
  }
  
  func executeWithAllocation(rawAllocations: String) throws -> Void {
    let cls: GenericClass = GenericClass(element: defaultValue)
    let allocations = Allocations(allocations: rawAllocations)
    // let type = (cls.element).getMyType()
    // let value = allocations.getValueFromAllocations(key: key, type: (cls.element as AnyObject).getMyType(), participant: participant)
  }
  
  func executeWithDefault() {
    self.function.apply(value: self.defaultValue)
  }
  
}