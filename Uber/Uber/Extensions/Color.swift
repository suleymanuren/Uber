//
//  Color.swift
//  Uber
//
//  Created by Bulut Sistem on 26.07.2023.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}
struct ColorTheme {
    let backgroundColor = Color("BackgroundColor")
    let secondaryBackgroundColor = Color("SecondaryBackgroundColor")
}
