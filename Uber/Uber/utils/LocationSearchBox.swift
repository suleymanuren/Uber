//
//  LocationSearchBox.swift
//  Uber
//
//  Created by Bulut Sistem on 10.07.2023.
//

import SwiftUI

struct LocationSearchBox: View {
    var body: some View {
        HStack{
            Rectangle()
                .fill(Color.black)
                .frame(width: 8,height: 8)
                .padding(.horizontal)
            
            Text("Where to?")
                .foregroundColor(Color(.darkGray))
            
            Spacer()
        }.frame(width: UIScreen.main.bounds.width - 64 , height: 50)
            .background(
            Rectangle()
                .fill(.white)
                .shadow(color: .black, radius: 2)
            )
    }
}

struct LocationSearchBox_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchBox()
    }
}
