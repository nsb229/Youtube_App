//
//  YoutubeVideoPlayer.swift
//  Youtube_App
//
//  Created by Nayana Sharma on 8/18/23.
//

import SwiftUI
import WebKit

struct YoutubeVideoPlayer: UIViewRepresentable {
    var video: Video
    
    func makeUIView(context: Context) -> WKWebView  {
        let view = WKWebView()
        
        // Set the background color for the view
        view.backgroundColor = UIColor(backgroundColor)
        
        // Create the embed URL
        let embedUrlString = Constants.YT_EMBED_URL + video.videoId
        
        // Load it into the webview
        let url = URL(string: embedUrlString)
        let request = URLRequest(url: url!)
        view.load(request)
        
        return view
    }
      
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeVideoPlayer(video: Video())
    }
}
