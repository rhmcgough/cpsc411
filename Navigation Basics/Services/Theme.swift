// Theme.swift
//
// This file contains the color scheme that the app will use
// for light and dark mode. Having everything in one place
// makes it easier to make changes to the color scheme.
//
// Dark Mode colors taken from XCode, since we use XCode a lot
// and know its a working color palette.

import SwiftUI

extension Color {

    // Main background:
    // Cream in Light Mode
    // #262626 in Dark Mode (Same as XCode)
    static let appBackground = Color(
        light: UIColor(red: 0.98, green: 0.96, blue: 0.92, alpha: 1),
        dark: UIColor(white: 0x26 / 255, alpha: 1)
    )

    // Cards, search bar, chips and sheets
    // white in Light Mode,
    // #303030 in Dark Mode (Same as XCode)
    static let appSecondaryBackground = Color(
        light: .white,
        dark: UIColor(white: 0x30 / 255, alpha: 1)
    )

    private init(light: UIColor, dark: UIColor) {
        self.init(UIColor { traits in traits.userInterfaceStyle == .dark ? dark : light }
        )
    }
}
