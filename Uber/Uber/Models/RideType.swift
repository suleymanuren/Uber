//
//  RideType.swift
//  Uber
//
//  Created by Bulut Sistem on 10.07.2023.
//

import Foundation


enum RideType : Int, CaseIterable, Identifiable {
    
    
    case uberX
    case uberBlack
    case uberXL
    
    var id : Int { return rawValue}
    
    var title : String {
        switch self {
        case .uberX : return "UberX"
        case .uberBlack : return "UberBlack"
        case .uberXL : return "UberXL"
        }
    }
    var imageName : String {
        switch self {
        case .uberX : return "uber-white"
        case .uberBlack : return "uber-black"
        case .uberXL : return "uber-white"
        }
    }
}
