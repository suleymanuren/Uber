//
//  HomeView.swift
//  Uber
//
//  Created by Bulut Sistem on 10.07.2023.
//

import SwiftUI

struct HomeView: View {
    @State private var showLocationSearchField = false
    var body: some View {
        ZStack (alignment: .top) {
            UberMapViewRepresentable()
                .edgesIgnoringSafeArea(.all)
           
            if showLocationSearchField {
                LocationSearch(showLocationSearchView: $showLocationSearchField)
                
            } else {
                LocationSearchBox()
                    .padding(.vertical,60)
                    .onTapGesture {
                        withAnimation {
                            showLocationSearchField.toggle()
                        }
                    }
            }
            ActionButton(isSearching: $showLocationSearchField)
                .padding(.leading)
                .padding(.vertical , 4)
          
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(LocationManager())
    }
}
