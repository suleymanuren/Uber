//
//  LocationSearchResult.swift
//  Uber
//
//  Created by Bulut Sistem on 10.07.2023.
//

import SwiftUI

struct LocationSearchResult: View {
    let title : String
    let subtitle : String
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(.blue)
                .accentColor(.white)
                .frame(width: 40, height: 40)
            
            VStack (alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.body)
                Text (subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
                Divider()
            }
        }.padding()
    }
}

struct LocationSearchResult_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchResult(title: "Star", subtitle: "123")
    }
}
