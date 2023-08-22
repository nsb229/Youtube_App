//
//  RatingModel.swift
//  Youtube_App
//
//  Created by Nayana Sharma on 8/20/23.
//

import Foundation
import Alamofire

class RatingModel: ObservableObject {
    
    var video: Video
    var accessToken: String
    
    @Published var isLiked = false
    @Published var isSubscribed = false
    
    var subscriptionId: String?
    
    init(video: Video, accessToken: String) {
        self.video = video
        self.accessToken = accessToken
        
        // Set the initial status for the UI
        getRating()
        getSubscriptionStatus()
    }
    
}

// Support for reading and updating the like status for a video
extension RatingModel {
    
    /// Gets the current users rating for the video.
    func getRating() {
        
        AF.requestYoutube(
            relativeUrl: "videos/getRating",
            method: .get,
            parameters: ["id": video.videoId, "key": Constants.API_KEY],
            accessToken: accessToken
        ) { response in
            
            // Get the rating from the response JSON
            if let json = response.value as? [String: Any],
               let items = json["items"] as? [[String: String]],
               let rating = items.first?["rating"]
            {
                // Update the UI with the rating's value
                DispatchQueue.main.async {
                    // We do not provide support for dislike. Here, a video is liked or otherwise.
                    self.isLiked = rating == "like"
                }
                
            } else {
                print("Could not get rating")
            }
        }
        
    }
    
    /// Changes the current users rating for the video.
    func toggleLike() {
        
        // If the video is currently liked, send a rating of none to remove the like.
        // Otherwise, send a rating of like.
        let rating = isLiked ? "none" : "like"
        
        AF.requestYoutube(
            relativeUrl: "videos/rate",
            method: .post,
            parameters: ["id": video.videoId, "rating": rating, "key": Constants.API_KEY],
            accessToken: accessToken
        ) { response in
            
            // Upon success, flip the value in the UI
            DispatchQueue.main.async {
                self.isLiked.toggle()
            }
        }
                
    }
}

// Support for reading and updating the subscription status of the channel
extension RatingModel {
    
    /// Gets the current user's subscription status for the channel.
    func getSubscriptionStatus() {
        
        AF.requestYoutube(
            relativeUrl: "subscriptions",
            method: .get,
            parameters: ["part": "id", "forChannelID": Constants.CHANNEL_ID, "mine": true, "key": Constants.API_KEY],
            accessToken: accessToken
        ){ response in
            
            // Get the response items from the JSON
            if let json = response.value as? [String: Any], let items = json["items"] as? [Any] {
                
                // Try to get the subscription ID (available if the user is subscribed)
                if let item = items.first as? [String: String], let id = item["id"] {
                    self.subscriptionId = id
                }
                
                // Update the UI
                DispatchQueue.main.async {
                    // The user is subscribed when there were items returned.
                    // An empty array of items indicates they do not have a subscription for this channel.
                    self.isSubscribed = !items.isEmpty
                }
                
            } else {
                print("Could not get subscriptions")
            }
        }
    }
    
    /// Changes the users subscription status for the channel.
    func toggleSubsribe() {
        
        if isSubscribed {
            unsubscribe()
        } else {
            subscribe()
        }
    }
    
    /// Subscribes a user to the channel.
    func subscribe() {
        
        // HTTP body to send along with the request.
        // The API requires we provide a subscription snippet so it can access the proper channel.
        let body: [String: Any] = [
            "snippet": [
                "resourceId": [
                    "channelId": Constants.CHANNEL_ID,
                    "kind": "youtube#channel"
                ]
            ]
        ]
        
        AF.requestYoutube(
            relativeUrl: "subscriptions?part=snippet&key=\(Constants.API_KEY)", // Must encode url parameters into string since we are specifying JSON encoding
            method: .post,
            json: true, // We set json to true so that a request body is sent along in JSON format
            parameters: body,
            accessToken: accessToken
        ) { response in
            
            // Get the subscription ID from the response
            if let json = response.value as? [String: Any], let id = json["id"] as? String {
                
                // Update the current subscription ID
                self.subscriptionId = id
                
                // Update the UI
                DispatchQueue.main.async {
                    self.isSubscribed = true
                }
                
            } else {
                print("Could not subscribe")
            }
        }
        
    }
    
    /// Unsubscribes a user from the channel.
    func unsubscribe() {
        
        // We must have a subscription ID to unsubscribe.
        guard let subscriptionId = subscriptionId else {
            print("Error: Tried to unsubscribe with no subscription ID.")
            return
        }
        
        AF.requestYoutube(
            relativeUrl: "subscriptions",
            method: .delete,
            parameters: ["id": subscriptionId, "key": Constants.API_KEY],
            accessToken: accessToken
        ) { response in
            
            // Clear the current subscription ID
            self.subscriptionId = nil
            
            // Update the UI
            DispatchQueue.main.async {
                self.isSubscribed = false
            }
        }
    }
    
}

