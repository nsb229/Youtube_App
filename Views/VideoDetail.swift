//
//  VideoDetail.swift
//  Youtube_App
//
//  Created by Nayana Sharma on 8/18/23.
//

import SwiftUI
import AVKit

struct VideoDetail: View {
    @EnvironmentObject var signInManager: GoogleSignInManager
    var video: Video
    
    var date: String {
        // Get a formatted date string from the video's date
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d, yyyy"
        return df.string(from: video.published)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Display the video's title
            Text(video.title)
                .bold()
            
            // Display the date
            Text(date)
                .foregroundColor(.gray)
            
            // Display the video player
            YoutubeVideoPlayer(video: video)
                .aspectRatio(CGSize(width: 1280, height: 720), contentMode: .fit)
            
            // If the user is signed in, show the option to like and subscribe
            if signInManager.signedIn {
                LikeAndSubscribe(video: video, accessToken: signInManager.accessToken)
                    // Set the buttons to fade in on insert
                    .transition(.opacity)
                    // Use the parent view's animation
                    .animation(.default)
            }
            
            // Display the video's text description
            ScrollView {
                Text(video.description)
            }
        }
        .font(.system(size: 19))
        .padding()
        .padding(.top, 40)
    }
}

struct VideoDetail_Previews: PreviewProvider {
    static var previews: some View {
        VideoDetail(video: Video())
            .environmentObject(GoogleSignInManager())
    }
}
