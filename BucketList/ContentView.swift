//
//  ContentView.swift
//  BucketList
//
//  Created by Sarvad shetty on 2/2/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .onTapGesture {
                let str = "Text message"
                let url2 = FileManager.default.getUrl("message.txt")
                let url = self.getDocumentDirectory().appendingPathComponent("message.txt")
                do {
                    try str.write(to: url2, atomically: true, encoding: .utf8)
                    let input = try String(contentsOf: url2)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
        }
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension FileManager {
    func getUrl(_ appendingFilePath: String) -> URL {
        let url = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return url.appendingPathComponent(appendingFilePath)
    }
}
