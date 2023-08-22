//
//  CacheManager.swift
//  Youtube_App
//
//  Created by Nayana Sharma on 8/18/23.
//

import Foundation

class CacheManager {
    
    static var cache = [String : Data]()
    
    static func setVideoCache (_ url: String, _ data: Data?)
    {
        
        //Store image data with url as key
        cache[url] = data
        
        
    }
    
    static func getVideoCache(_ url: String)-> Data? {
        
        //Try and get data for specified URL
        return cache[url]
    }
    
    
}
    
   
