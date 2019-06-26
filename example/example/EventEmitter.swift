//
//  EventEmitter.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import SwiftyJSON

public class EventEmitter {
  
  public static let CONFIRM_KEY: String = "confirmation"
  public static let CONTAMINATE_KEY: String = "contamination"
  
  let httpClient: HttpClient
  let config: AscendConfig
  let participant: AscendParticipant
  
  let audience = Audience()
  
  init(httpClient: HttpClient = HttpClient(),
               config: AscendConfig,
               participant: AscendParticipant) {
    self.httpClient = httpClient
    self.config = config
    self.participant = participant
  }
  
  func emit(_ key: String) -> Void {
    let url: URL = createEventUrl(key, 1.0)
    makeEventRequest(url)
  }
  
  func emit(_ key: String, _ score: Double) -> Void {
    let url: URL = createEventUrl(key, score);
    makeEventRequest(url);
  }
  
  public func confirm(allocations: [JSON]) -> Void {
    sendAllocationEvents(EventEmitter.CONFIRM_KEY, allocations);
  }
  
  public func contaminate(allocations: [JSON]) -> Void {
    sendAllocationEvents(EventEmitter.CONTAMINATE_KEY, allocations);
  }

  public func sendAllocationEvents(_ key: String, _ allocations: [JSON]) {
    if allocations.count > 0 {
      for a in allocations {
        let eid = String(describing: a["eid"])
        let cid = String(describing: a["cid"])
        let url = createEventUrl(type: key, experimentId: eid, candidateId: cid)
        do {
          makeEventRequest(url) // confirm this is async, and make this throwing
        } catch let error {
          let message: String = "Error sending allocation event: \(error.localizedDescription)"
          Log.logger.log(.debug, message: message)
        }
      }
    }
  }
  
  func createEventUrl(_ type: String , _ score: Double ) -> URL {
    var components = URLComponents()
   
      components.scheme = config.getHttpScheme()
      components.host = config.getDomain()
      components.path = "/\(config.getVersion())/\(config.getEnvironmentId())/events"
      components.queryItems = [
        URLQueryItem(name: "uid", value: "\(participant.getUserId())"),
        URLQueryItem(name: "sid", value: "\(participant.getSessionId())"),
        URLQueryItem(name: "type", value: "\(type)"),
        URLQueryItem(name: "score", value: "\(String(score))")
      ]
      
      guard let url = components.url else {
        let message: String = "Error creating event url with type and score."
        Log.logger.log(.debug, message: message)
        return URL(string: "")!
      }
      return url
  }

  func createEventUrl(type: String, experimentId: String, candidateId: String) -> URL {
    var components = URLComponents()
  
    components.scheme = config.getHttpScheme()
    components.host = config.getDomain()
    components.path = "/\(config.getVersion())/\(config.getEnvironmentId())/events"
    components.queryItems = [
      URLQueryItem(name: "uid", value: "\(participant.getUserId())"),
      URLQueryItem(name: "sid", value: "\(participant.getSessionId())"),
      URLQueryItem(name: "eid", value: "\(experimentId)"),
      URLQueryItem(name: "cid", value: "\(candidateId)"),
      URLQueryItem(name: "type", value: "\(type)")
    ]
    
    guard let url = components.url else {
      let message: String = "Error creating event url with Experiment ID and Candidate ID."
      Log.logger.log(.debug, message: message)
      return URL(string: "")!
    }
    return url
  }
  
  private func makeEventRequest(_ url: URL?) -> Void {
    let semaphore = DispatchSemaphore(value: 0) // Do we really need this here?
    guard let url = url else {
      let message = "The event url was nil, skipping event request."
      Log.logger.log(.debug, message: message)
      return
    }

//    httpClient.get(withUrl: url, semaphore: semaphore)
//    semaphore.signal()
  }
}
