//
//  Helper+Extensions.swift
//  BucketList
//
//  Created by Sarvad shetty on 2/3/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import Foundation


extension FileManager {
    func getUrl(_ appendingFilePath: String) -> URL {
        let url = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return url.appendingPathComponent(appendingFilePath)
    }
}
