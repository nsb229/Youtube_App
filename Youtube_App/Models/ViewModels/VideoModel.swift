//
//  VideoModel.swift
//  Youtube_App
//
//  Created by Nayana Sharma on 8/17/23.
//

import Foundation

class VideoModel: ObservableObject {
    
    @Published var videos = [Video]()
    
    init()
    {
        getVideos()
    }
    
    func getVideos()
    {
        
        //create a URL object
        guard let url = URL(string: "\(Constants.API_URL)/playlistItems") else {
            return
        }
        
        //Get a decoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        //create a url request
        
        AF.request(
            url,
            parameters: ["part": "snippet", "playlistId": Constants.PLAYLIST_ID, "key": Constants.API_KEY ]
        )
            .validate()
            .responseDecodable(of: Response.self, decoder: decoder)
            { response in
                
                //Check call was successful
                switch response.result
                {
                case .success:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    return
                }
                //Update the UI with videos
                if let items = response.value?.items
                {
                    DispatchQueue.main.async
                    {
                        self.videos = items
                    }
                }
            }
    }
    
}
