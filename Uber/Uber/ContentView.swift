//
//  ContentView.swift
//  Uber
//
//  Created by Bulut Sistem on 10.07.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationViewModel = LocationSearchViewModel()

    var body: some View {
        HomeView()
            .environmentObject(locationViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
