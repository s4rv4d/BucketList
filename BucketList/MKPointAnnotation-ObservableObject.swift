//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Sarvad shetty on 2/4/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown value"
        }
        set {
            subtitle = newValue
        }
    }
}
