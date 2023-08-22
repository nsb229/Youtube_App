//
//  LikeAndSubscribe.swift
//  Youtube_App
//
//  Created by Nayana Sharma on 8/20/23.
//

import SwiftUI

struct LikeAndSubscribe: View {
    @ObservedObject var ratingModel: RatingModel
    
    init(video: Video, accessToken: String) {
        // Create the rating model from the video and token
        self.ratingModel = RatingModel(video: video, accessToken: accessToken)
    }
    
    var likeText: String {
        // If the video is liked, the text should say "Unlike"
        // Otherwise, the option is to like the video
        return ratingModel.isLiked ? "Unlike" : "Like \u{1f44d}"
    }
    
    var subscribeText: String {
        // If the user is subscribed, the option is to "Unsubscribe"
        // Otherwise, the option is to subscribe
        return ratingModel.isSubscribed ? "Unsubscribe" : "Subscribe"
    }
    
    var body: some View {
        // Display the buttons to like and subscribe in a horizontal stack
        // Space them out so they are centered apart
        HStack {
            Spacer()
            
            Button(likeText) {
                // Toggle the user's rating for the video
                ratingModel.toggleLike()
            }
            
            Spacer()
            
            Button(subscribeText) {
                // Toggle the user's subscription status for the video
                ratingModel.toggleSubsribe()
            }
            
            Spacer()
        }
    }
}

struct LikeAndSubscribe_Previews: PreviewProvider {
    static var previews: some View {
        LikeAndSubscribe(video: Video(), accessToken: "")
    }
}
