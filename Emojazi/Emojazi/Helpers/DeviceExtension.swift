//
//  DeviceExtension.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/08/2025.
//

import UIKit

extension UIDevice {
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom != .phone
    }
}
