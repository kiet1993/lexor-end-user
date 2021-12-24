//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension TimeInterval {

    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        _ = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        _ = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        //%0.2d:%0.2d:%0.2d.%0.3d
        return String(format: "%0.2dh %0.2dm", hours, minutes)
    }
}
