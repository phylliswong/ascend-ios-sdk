//
//  ViewController.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import PromiseKit

class ViewController: UIViewController {
  
 
  @IBOutlet weak var textView: UITextView!
  
  let store = DefaultAllocationStore(size: 1000)
  var allocations = [JSON]()

  @IBAction func didPressAlloc(_ sender: Any) {
    getJsonData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}


private extension ViewController {
  
  private func getJsonData() -> Void {
    let envId = "40ebcd9abf"
    let httpClient = EvolvHttpClient()
    let config = EvolvConfig.builder(environmentId: envId, httpClient: httpClient).build()
    let participant = EvolvParticipant.builder().build()
    let client = EvolvClientFactory(config: config, participant: participant).client as! EvolvClientImpl
    
//    let _ = client.futureAllocations?.done({ (json) in
//      self.allocations = json
//      print("THE FUTURE IS HERE: \(json)")
//      self.store.set(uid: participant.getUserId(), allocations: json)
//      let cachedJson = self.store.get(uid: participant.getUserId())!
//      let reconciled = Allocations.reconcileAllocations(previousAllocations: cachedJson, currentAllocations: json)
//      self.allocations = reconciled
//      self.textView.text = String(describing: reconciled)
//    })
    let someValue = client.get(key: "button", defaultValue: "green")
    print(someValue)
  }
  
  private func buildClient() -> EvolvClientImpl {
    let envId = "40ebcd9abf"
    let httpClient = EvolvHttpClient()
    let config = EvolvConfig.builder(environmentId: envId, httpClient: httpClient).build()
    let participant = EvolvParticipant.builder().build()
    return EvolvClientFactory(config: config, participant: participant).client as! EvolvClientImpl
  }
}
