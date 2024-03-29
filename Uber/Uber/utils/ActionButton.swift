//
//  ActionButton.swift
//  Uber
//
//  Created by Bulut Sistem on 10.07.2023.
//

import SwiftUI

struct ActionButton: View {
    @Binding var mapState : MapViewState
    @EnvironmentObject var viewModel : LocationSearchViewModel
    var body: some View {
        
        Button {
            actionForState(mapState)
        } label: {
            Image(systemName:  imageNameForState(mapState))
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity , alignment: .leading)
        

    }
    
    func actionForState (_ state : MapViewState) {
        switch state {
        case .noInput:
            print("no input")
        case.locationSelected , .polylineAdded:
            mapState = .noInput
            viewModel.selectedUberLocation = nil //geri gidildiğinde bir önce ki kordinatları boşaltıyor
        case.searchingForLocation:
            mapState = .noInput
        }
    }
    
    func imageNameForState (_ state : MapViewState) -> String{
        switch state {
        case .noInput:
            return "line.3.horizontal"
            
        case.locationSelected, .searchingForLocation , .polylineAdded:
            return "arrow.left"
            
        default:
            return "line3.horizontal"
        }
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(mapState: .constant(.noInput))
    }
}
