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
  
  @IBOutlet weak var textLabel: UITextField!
  let store = LRUCache.share
  var allocations = JsonArray()
  enum DataError: Error { // move this somewhere more sensible
    case taskError
  }

  @IBAction func didPressAlloc(_ sender: Any) {
    let url = URL(string: "https://participants-phyllis.evolv.ai/v1/40ebcd9abf/allocations?uid=123")!
    let httpClient = HttpClient()
//    let jsonPromise = httpClient.get(url: url).done { (fetched) in
//      self.allocations.append(JSON(fetched))
//    }
    // FIXME: call the alloc.fetch method here to test > you want to get a promise back
    let cacheName = "MyCache"
    store.set(cacheName, val: allocations)
    let cached = store.get(cacheName)
    print("CACHED: \(cached)")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let store = LRUCache.share
    // self.getData()
//    let client = buildClient()
//    print(client)
  }
}


private extension ViewController {
  
 
//  private func getJsonData() {
//    let participantBuilder = ParticipantBuilder()
//    let participant = participantBuilder.build()
//    let client = buildClient()
//    print(client)
//    let httpClient = HttpClient()
//    let envId = "40ebcd9abf"
//    let config = ConfigBuilder(environmentId: envId).buildConfig()
//    let store = LRUCache(10)
//    let alloc = Allocator(config: config, participant: participant)
//    let results = alloc.fetchAllocations()
//    let cached = store.get(config.getEnvironmentId())
//    print("YOUR FETCHED ALLOCATION: \(String(describing: results))")
//    print("YOUR CACHED ALLOCATION: \(String(describing: cached))")
//  }
  
  private func buildClient() -> AscendClientFactory {
    let envId = "40ebcd9abf"
    let config = ConfigBuilder(environmentId: envId).buildConfig()
    let participantBuilder = ParticipantBuilder()
    let participant = participantBuilder.build()
    return AscendClientFactory(config: config, participant: participant)
  }
  
//  private func getData() {
//    let participantBuilder = ParticipantBuilder()
//
//    let participant = participantBuilder.build()
//    let httpClient = HttpClient()
//    let envId = "40ebcd9abf"
//    let config = ConfigBuilder(environmentId: envId).buildConfig()
//    let store = LRUCache(10)
//    let alloc = Allocator(config: config, participant: participant)
//    let futureAlloc = alloc.fetchAllocations()
//    let emitter = EventEmitter(httpClient: httpClient, config: config, participant: participant)
//    let ascender = AscendClientImpl(config: config, allocator: alloc, previousAllocations: false, participant: participant, eventEmitter: emitter, futureAllocations: futureAlloc)
//    let value = ascender.get(key: "button", defaultValue: "green")
//    print("THIS IS YOUR VALUE: \(value)")
//  }
}
