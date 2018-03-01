//
//  StratusModel.swift
//  Stratus
//
//  Created by student on 2/28/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation

struct StratusModel {
    static let ASIPOffset: Int = 3
    static let StatusPayloadByteRange = 5..<217
    static let GPSPayloadByteRange = 5..<46
    
    static let StatusASIPID: UInt8 = 16
    static let GPSASIPID: UInt8 = 64
    
    
    static let BatteryByteRange = 63..<65
    static let GPSReceiverFlagsByteRange = 36..<37
    static let LongitudeByteRange = 14..<18
    static let LatitudeByteRange = 10..<14
    static let GroudSpeedByteRange = 26..<28
    static let AltitudeMSLByteRange = 22..<26
    static let VerticalSpeedByteRange = 30..<32
    
    static let GPSFixValidBitValue: UInt8 = 0b00010000
}
