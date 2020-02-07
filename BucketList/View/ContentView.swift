//
//  ContentView.swift
//  BucketList
//
//  Created by Sarvad shetty on 2/2/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//


import LocalAuthentication
import MapKit
import SwiftUI

struct ContentView: View {
    
    //MARK: - Conditional view properties
    enum ViewState {
        case unlocked, locked
    }
    
    //MARK: - Properties
    @State private var viewState = ViewState.locked
    @State private var showAlert = false
    
    var body: some View {
        AnyView(ZStack { () -> AnyView in
            if viewState == .unlocked {
                return AnyView(UnlockwdView())
            } else {
                //button to authenticate
                   return AnyView(Button("Unlock Places") {
                        self.authenticate()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule()))
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("No biometric detected"))
        })
    }
    
    //MARK: - Function
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
//                        self.isUnlocked = true
                        self.viewState = .unlocked
                    } else {
                        //there was a problem
                        
                    }
                }
            }
        } else {
            //no biometric system available
            self.showAlert = true
        }
    }

}

struct UnlockwdView: View {
    
    //MARK: - Properties
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false
    
    var body: some View {
        ZStack {
            MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
                .overlay(Image(systemName: "plus"))
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        //action
                        let newLocation = CodableMKPointAnnotation()
                        newLocation.title = "Example location"
                        newLocation.coordinate = self.centerCoordinate
                        self.locations.append(newLocation)
                        
                        self.selectedPlace = newLocation
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus")
                    }
                .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }.alert(isPresented: $showingPlaceDetails) {
                Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information"), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")){
                  //editing action
                    self.showingEditScreen = true
                })
            }
            .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
                if self.selectedPlace != nil {
                    EditView(placemark: self.selectedPlace!)
                }
            }
        .onAppear(perform: loadData)
    }
    
    //MARK: - Function
    func getDocumentUrl() -> URL {
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           return paths[0]
       }
       
       func loadData() {
           let fileName = getDocumentUrl().appendingPathComponent("SavedPlaces")
           
           do {
               let data = try Data(contentsOf: fileName)
               locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
           } catch {
               print("Unable to load saved data.")
           }
       }
       
       func saveData() {
           do {
               let fileName = getDocumentUrl().appendingPathComponent("SavedPlaces")
               let data = try JSONEncoder().encode(self.locations)
               try data.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
           } catch {
               print("Unable to save data")
           }
       }
}
