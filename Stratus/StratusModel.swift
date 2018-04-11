//
//  StratusModel.swift
//  Stratus
//
//  Created by student on 2/28/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation

struct StratusModel {
    static let StatusPort: UInt16 = 41501
    static let GPSPort: UInt16 = 41502
    
    static let ASIPOffset = 3
    static let StatusPayloadByteRange = 5..<217
    static let GPSPayloadByteRange = 5..<46
    
    static let StatusASIPID: UInt8 = 16
    static let GPSASIPID: UInt8 = 64
    
    
    static let BatteryByteRange = 63..<65
    static let GPSReceiverFlagsByteRange = 36..<37
    static let LongitudeByteRange = 14..<18
    static let LatitudeByteRange = 10..<14
    static let GroundSpeedByteRange = 26..<28
    static let GroundTrackByteRange = 28..<30
    static let AltitudeMSLByteRange = 22..<26
    static let VerticalSpeedByteRange = 30..<32
    static let TransmitPowerByteRange = 71..<72
    
    static let GPSFixValidBitValue: UInt8 = 0b00010000
    
    static func convertToCoords( coord: Int32 ) -> Double {
        return Double( coord ) / pow( 10, 7 )
    }
    
    static func convertAltitude( rawAltitude: Int32, measure: Double ) -> Double {
        // Altitude is measured in millimeters by default. This converts it to meters, then to the desired measurement.
        return Double( rawAltitude ) * pow( 10,-3 ) / measure
    }
    
    static func convertSpeed( rawSpeed: Int16, measure: Double, time: String ) -> Double {
        // Speed is measured in centimeters per second by default. This converts it to meters, then to the desired measurement.
        switch time {
        case "s":
            return Double( rawSpeed ) * pow( 10,-2 ) / measure
        case "m":
            return Double( rawSpeed ) * pow( 10,-2 ) / ( measure * 60 )
        default:
            return Double( rawSpeed ) * pow( 10,-2 ) / ( measure * 60 * 60 )
        }
    }
    
    static func convertGroundTrack( rawBearing: UInt16 ) -> Double {
        return Double( rawBearing ) * pow( 10,-2 )
    }
}
