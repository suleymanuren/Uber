//
//  HomeView.swift
//  Uber
//
//  Created by Bulut Sistem on 10.07.2023.
//

import SwiftUI

struct HomeView: View {
    @State private var mapState = MapViewState.noInput
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    var body: some View {
        ZStack (alignment: .bottom){
            ZStack (alignment: .top) {
                UberMapViewRepresentable(mapState: $mapState)
                    .edgesIgnoringSafeArea(.all)
               
                if mapState == .searchingForLocation {
                    LocationSearch(mapState: $mapState)
                    
                    
                } else if mapState == .noInput {
                    LocationSearchBox()
                        .padding(.vertical,60)
                        .onTapGesture {
                            withAnimation {
                                mapState = .searchingForLocation
                            }
                        }
                }
                ActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.vertical , 4)
              
            }
            
            if mapState == .locationSelected || mapState == .polylineAdded {
                RideRequest()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
                if let location = location {
                    locationViewModel.userLocation = location
                }
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
