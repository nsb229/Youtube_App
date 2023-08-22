//
//  Home.swift
//  Youtube_App
//
//  Created by Nayana Sharma on 8/19/23.
//

import SwiftUI
import GoogleSignIn

let backgroundColor = Color(red: 31 / 255, green: 33 / 255, blue: 36 / 255)

struct Home: View {
    @EnvironmentObject var signInManager: GoogleSignInManager
    @StateObject var model = Model()
    @State private var rowSize: CGSize = .zero
    
    var body: some View {
        VStack {
            
            // If the user hasn't signed in, show the sign in button
            if !signInManager.signedIn {
                GoogleSignInButton()
                    .padding()
                    .frame(height: 48)
                    // Move in and out from the top on appear/disappear
                    .transition(.move(edge: .top))
            }
            
            ScrollView {
                LazyVStack {
                    ForEach(model.videos, id:\.videoId) { video in
                        // Display a video row for each video
                        VideoRow(videoPreview: VideoPreview(video: video))
                            // Add padding between the rows
                            .padding()
                    }
                }
                .padding(.top, 10)
            }
            
            // If the user is signed in, show the sign out button
            if signInManager.signedIn {
                Button("Sign out") {
                    // Sign out
                    GIDSignIn.sharedInstance().signOut()
                    // Update the sign in manager
                    signInManager.signedIn = false
                }
                .padding()
                // Move in and out from the bottom on appear/disappear
                .transition(.move(edge: .bottom))
            }
        }
        // Set the text color to be white against the dark background
        .foregroundColor(.white)
        // Set the background color to the custom colour, ignoring the safe area
        .background(backgroundColor.edgesIgnoringSafeArea(.all))
        // Animate transitions in this view to ease out
        .animation(.easeOut)
        .onAppear {
            // Restore the users sign in status when the view appears
            GIDSignIn.sharedInstance().restorePreviousSignIn()
        }
        .onOpenURL(perform: { url in
            // Open sign in URL when the button is clicked
            // We can do this because the sign in button is the only URL on this page
            GIDSignIn.sharedInstance().handle(url)
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(GoogleSignInManager())
    }
}
