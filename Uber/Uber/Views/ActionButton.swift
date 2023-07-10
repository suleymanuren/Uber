//
//  ActionButton.swift
//  Uber
//
//  Created by Bulut Sistem on 10.07.2023.
//

import SwiftUI

struct ActionButton: View {
    @Binding  var isSearching : Bool
    var body: some View {
        
        Button {
            isSearching.toggle()
        } label: {
            Image(systemName: isSearching ? "arrow.left" : "line.3.horizontal")
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity , alignment: .leading)
        

    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(isSearching: .constant(false))
    }
}
