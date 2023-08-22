//
//  YoutubeRequest.swift
//  Youtube_App
//
//  Created by Nayana Sharma on 8/20/23.
//

import Foundation
import Alamofire

extension Session {
    
    /// Sends an authenticated request to the Youtube Data V3 API.
    func requestYoutube(
        relativeUrl: String,
        method: HTTPMethod,
        json: Bool = false,
        parameters: Parameters? = nil,
        accessToken: String,
        completion: ((AFDataResponse<Any>) -> Void)? = nil
    ) {
        
        // Create a URL from the provided path
        guard let url = URL(string: "\(Constants.API_URL)/\(relativeUrl)") else {
            print("Couldn't get URL for relative path \(relativeUrl)")
            return
        }
        
        AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: json ? JSONEncoding.default : URLEncoding.default,
            headers: ["Authorization": "Bearer \(accessToken)", "Accept": "application/json"]
        )
        .validate().responseJSON { response in
            
            // Check the status of the request
            switch response.result {
            case .success:
                break
            case .failure(let error):
                print("Youtube data V3 API call failed with error \(error.failureReason ?? error.localizedDescription)")
                return
            }
            
            // Call the completion handler if one was provided
            if let completion = completion {
                completion(response)
            }
            
        }
    }
    
}
