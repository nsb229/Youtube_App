//
//  GoogleSignInButton.swift
//  Youtube_App
//
//  Created by Nayana Sharma on 8/20/23.
//

import SwiftUI
import GoogleSignIn

struct GoogleSignInButton: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        
        // Create the view
        let view = GIDSignInButton()
        
        // Set it's presenting view controller
        // Since this button is being displayed on the home screen of a single window application,
        //   we can set it's parent to the root view controller of the first window
        GIDSignIn.sharedInstance.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        
        // Return the configured button
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInButton()
    }
}

