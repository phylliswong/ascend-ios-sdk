//
//  Networking.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import PromiseKit
import DynamicJSON
import Alamofire

protocol Networking {
  func get(fromUrl url: URL, completion: @escaping (Any) -> Void)
}

struct NetworkingService {
  
  static let sharedInstance = NetworkingService()
  
  public func get(fromUrl url: URL, completion: @escaping (Data?, URLResponse?, NetworkingError?) -> Void) {
    let session = URLSession.shared
    let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
    let logger = Log.BasicLogger()
      
      if let err = error {
        logger.log(.error, message: err.localizedDescription)
        let fileUrl = Bundle.main.url(forResource: "logs", withExtension: "txt")
        
        // writing
        do {
          let errorMessage = String(stringLiteral: "Error Occured \(err.localizedDescription)")
          try errorMessage.write(to: fileUrl!, atomically: true, encoding: .utf8)
        } catch {
          print("Error writing to log")
        }
        // reading
        do {
          let text = try String(contentsOf: fileUrl!, encoding: .utf8)
          print("REQUESTED TEXT: \(text)")
        } catch {
          print("error reading")
        }
        return
      }
      
      // 2 check the status code
      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
          // self.handleServerError(response)
          print("Server Error")
          return
      }
      
      // 3 check that we got back JSON and not html or xml or some wack shit
      guard let mime = response?.mimeType, mime == "application/json" else {
        print("Wrong MIME type!")
        return
      }
      
      // 4 serialize the data to json
      do {
        completion(data, response, error as? NetworkingError)
      } catch {
        print("JSON error: \(NetworkingError.invalidRequest)")
      }
    })
    task.resume()
  }
}
// let safeUrlString = "https://participants-phyllis.evolv.ai/v1/40ebcd9abf/allocations?uid=123"
// - MARK: final class makes it so it can't be extended or overridden
public class HttpClient  {
  
  // FIXME: change Any to NSDictionary for this method
  public func get(withUrl url: URL, semaphore: DispatchSemaphore) -> [JSON] {
    
    var jsonArray = [JSON()]
    NetworkingService.sharedInstance.get(fromUrl: url, completion: { (_data, res, err) in

      if let error = err {
        Log.logger.log(.debug, message: "Error : \(error.localizedDescription)")
      }
      
      guard let response = res, let data = _data else {
        Log.logger.log(.debug, message: "NetworkingError data")
        return
      }
      
      jsonArray = [JSON(data)]
      semaphore.signal() // tell the semaphore that we are done
    })
    return jsonArray
  }
  
  public func post(url: String, jsonArray: [[String : Any]]) {
    print("working on it")
  }
}

public class ApiService {
  public func get(url: URL, completion: @escaping (Any?) -> ()) -> JSON {
    let semaphore = DispatchSemaphore(value: 0)
    var json = JSON()
    Alamofire.request(url).responseData() { (response) in
      guard response.result.isSuccess else {
        return
      }
      if let data = response.data {
        do {
          let jsonData = try JSON(data: data)
          print("JSON: \(jsonData)")
          json = jsonData
          semaphore.signal()
        } catch {
          print("JSON ERROR")
        }
      }
    }
    _ = semaphore.wait(timeout: .distantFuture)
    return json
  }
}

