//
//  Double.swift
//  Uber
//
//  Created by Bulut Sistem on 26.07.2023.
//

import SwiftUI

extension Double {
    private var currencyFormatter : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func toCurrency () -> String {
        return currencyFormatter.string(for: self) ?? ""
    }
}
