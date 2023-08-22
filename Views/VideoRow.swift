//
//  VideoRow.swift
//  Youtube_App
//
//  Created by Nayana Sharma on 8/18/23.
//

import SwiftUI

struct VideoRow: View {
    @ObservedObject var videoPreview: VideoPreview
    @State private var isPresenting = false
    @State private var imageHeight: CGFloat = 0
    
    var body: some View {
            Button(action: {
                // Present the detail sheet on click
                isPresenting = true
            }) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    GeometryReader { geometry in
                        
                        // Create an image from the video preview's data
                        Image(uiImage: UIImage(data: videoPreview.thumbnailData) ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            // Set the aspect ratio for the view to be 16 : 9
                            .frame(width: geometry.size.width, height: geometry.size.width * 9 / 16)
                            .clipped()
                            .onAppear {
                                // Update the height of the image
                                imageHeight = geometry.size.width * 9 / 16
                            }
                    }
                    // We set the height explicitly so the geometry reader's proposed height is not collapsed
                    .frame(height: imageHeight)
                    
                    // Display the video's title
                    Text(videoPreview.title)
                        .bold()
                    
                    // Display the video's date
                    Text(videoPreview.date)
                        .foregroundColor(.gray)
                }
                .font(.system(size: 19))
            }
            .sheet(isPresented: $isPresenting, content: {
                // Display the detail view for the video
                VideoDetail(video: videoPreview.video)
                    // Set the background color for the detail view to the custom color, ignoring the safe area
                    .background(backgroundColor.edgesIgnoringSafeArea(.all))
            })
    }
}

struct VideoRow_Previews: PreviewProvider {
    static var previews: some View {
        VideoRow(videoPreview: VideoPreview(video: Video()))
    }
}
