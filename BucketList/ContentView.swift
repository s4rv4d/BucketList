//
//  ContentView.swift
//  BucketList
//
//  Created by Sarvad shetty on 2/2/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//


import LocalAuthentication
import SwiftUI

struct ContentView: View {
    
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            if self.isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }.onAppear(perform: authenticate)
    }
    
    func authenticate() {
        //create and LAContext object
        let context = LAContext()
        //creating an optional error variable of type NSError cause this LA was built using objc
        var error: NSError?
        
        //check if biometric auth can be possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                //need to push to main thread to make UI Updates
                DispatchQueue.main.async {
                    if success {
                        //auth successfully
                        //use @State var
                        self.isUnlocked = true
                    } else {
                        //there was a problem
                    }
                }
            }
        } else {
            //no biometric system available
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

