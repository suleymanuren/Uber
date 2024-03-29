//
//  RideRequest.swift
//  Uber
//
//  Created by Bulut Sistem on 10.07.2023.
//

import SwiftUI

struct RideRequest: View {
    @State private var selectedRideType : RideType = .uberX
    @EnvironmentObject var locationSearchViewModel : LocationSearchViewModel
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48,height: 6)
                .padding(.top , 8 )
            
            //trip info
            HStack {
                VStack (spacing: 10) {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 10, height: 10)
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 2, height: 23)
                    Rectangle()
                        .fill(Color(.systemGreen))
                        .frame(width: 10, height: 10)
                    
                }
                .padding(.bottom , 10)
                
                
                VStack (alignment: .leading, spacing: 24){
                    
                    HStack {
                        Text("Current Location")
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(locationSearchViewModel.pickupTime ?? "")
                            .font(.system(size: 14 , weight:  .semibold ))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom , 10)
                    
                    HStack {
                        if let location = locationSearchViewModel.selectedUberLocation {
                            Text(location.title)
                                .font(.system(size: 16,weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text(locationSearchViewModel.dropOffTime ?? "")
                            .font(.system(size: 14 , weight:  .semibold ))
                            .foregroundColor(.black)
                    }
                    .padding(.bottom , 10)
                }
                .padding()
            }
            .padding()
            
            Divider()
            
            //ride type selection
            Text("Suggested Rides")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(Color(.gray))
                .frame(maxWidth: .infinity , alignment: .leading)

            ScrollView (.horizontal) {
                HStack (spacing: 12) {
                    ForEach (RideType.allCases , id: \.self) { ride in
                        VStack(alignment: .leading) {
                            Image(ride.imageName)
                                .resizable()
                                .scaledToFit()
                            VStack (spacing: 3){
                                Text (ride.title)
                                    .font(.system(size: 14 , weight:  .semibold ))
                                Text(locationSearchViewModel.computeRidePrice(forType: ride).toCurrency())
                                    .font(.system(size: 14 , weight:  .semibold ))
                                    
                            }.padding(8)
                        }
                        .frame(width: 112, height: 140)
                        .background(Color(ride == selectedRideType ? .systemBlue : .systemGroupedBackground))
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation {
                                selectedRideType = ride
                            }
                        }
                       
                    }
                }
            }.padding(.horizontal)
            
            Divider()
                .padding(.vertical)
            //payment option
            HStack {
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.black)
                    .padding(.leading)
                
                Text("**** 1234")
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
                
            }.frame(height: 50)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(10)
                .padding(.horizontal)
            
            //ride button
            Button {
                
            } label: {
                Text("Confirm Ride")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }

        }
        .padding(.bottom , 24 )
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)

    }
}

struct RideRequest_Previews: PreviewProvider {
    static var previews: some View {
        RideRequest()
    }
}
