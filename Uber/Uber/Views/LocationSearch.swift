//
//  LocationSearch.swift
//  Uber
//
//  Created by Bulut Sistem on 10.07.2023.
//

import SwiftUI

struct LocationSearch: View {
    @EnvironmentObject var viewModel : LocationSearchViewModel
    @Binding var mapState : MapViewState
    @State private var startLocation = ""
    var body: some View {
        VStack {
            HStack {
                VStack (spacing: 15) {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 30)
                    Rectangle()
                        .fill(Color(.systemGreen))
                        .frame(width: 6, height: 6)
                    
                }
                
                VStack{
                    TextField("Current Location", text: $startLocation)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    TextField("Destination Location", text: $viewModel.queryFragment)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
            }.padding()
            
            Divider()
            
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach (viewModel.results, id: \.self) { result in
                        LocationSearchResult(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectLocation(result)
                                    mapState = .locationSelected
                                }
                            }
                    }
                }
            }
        }
        .background(.white)
    }
}

struct LocationSearch_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearch(mapState: .constant(.searchingForLocation))
    }
}
