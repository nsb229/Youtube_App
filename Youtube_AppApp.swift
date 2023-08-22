//
//  Youtube_AppApp.swift
//  Youtube_App
//
//  Created by Nayana Sharma on 8/16/23.
//

import SwiftUI
import GoogleSignIn

@main
struct Youtube_AppApp: App {
    
    // Create a sign in manager to act as a delegate for GIDSignIn
    let signInManager = GoogleSignInManager()
    
    init() {
        
        // Set the client ID and delegate
        GIDSignIn.sharedInstance().clientID = Constants.GID_SIGN_IN_ID
        GIDSignIn.sharedInstance().delegate = signInManager
        
        // Specify that we need to authenticate users for youtube access
        GIDSignIn.sharedInstance().scopes.append(Constants.YT_AUTH_SCOPE)
        
    }
    
    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(signInManager)
        }
    }
}

