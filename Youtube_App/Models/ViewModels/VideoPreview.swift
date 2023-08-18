//
//  VideoPreview.swift
//  Youtube_App
//
//  Created by Nayana Sharma on 8/17/23.
//

import Foundation
import Alamofire

class VideoPreview: ObservableObject
{
    @Published var thumbnailData = Data()
    @Published var title: String
    @Published var date: String
    
    var video: Video
    
    init(video: Video) {
        
        //Set video and title
        self.video = video
        self.title = video.title
        
        //Set date
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d, yyyy"
        self.date = df.string(from: video.published)
        
        //Download the image data
        
        guard video.thumbnail != "" else {return}
        
        //Get a url from the thumbnail
        guard let url = URL(string: video.thumbnail) else { return }
        
        //Create the request
        AF.request(url).validate().responseData { response in
            
            if let data = response.data {
                //Set the image
                DispatchQueue.main.async {
                    
                    self.thumbnailData = data
                    
                }
            }
        }
    }
    
}
