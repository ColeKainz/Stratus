 //
 //  StratusDataFetch.swift
 //  Stratus
 //
 //  This is a singleton class that is responsible for connecting to and
 //  managing the data from the Stratus server.
 //
 //  Created by student on 2/9/18.
 //  Copyright © 2018 Cole Kainz. All rights reserved.
 //
 
 import Foundation
 
 class StratusDataFetcher {
    
    //The structure the recieved Stratus data will be stored in.
    public struct StratusDataStruct {
        var battery: UInt16 = 0
        var GPSValid: Bool = false
        var longitude: Int32 = 0
        var latitude: Int32 = 0
        var groundSpeed: UInt16 = 0
        var altitude: Int32 = 0
        var verticalSpeed: Int16 = 0
    }
    
    static let instance = StratusDataFetcher() // The shared instance of this class.
    
    private var observerArray = [ StratusObserver ]() // A list used to notify all observers of an update.
    private var stratusData = StratusDataStruct() // The data structure that this class will update then share with the observers.
    
    private var statusSocket: UDPSocket? = nil // The socket that will stream the stratus status.
    private var gpsSocket: UDPSocket? = nil // The socket that will stream GPS information.
    
    private init() {}
    
    // Updates all observers.
    internal func notify() {
        for observer in observerArray {
            observer.update(stratusData: stratusData)
        }
    }
    
    func attachObserver(observer: StratusObserver) {
        observerArray.append(observer)
    }
    
    internal func onRecieveStatus(data: Data) {
        let dataArr = data.withUnsafeBytes {
            Array(UnsafeBufferPointer<UInt8>(start: $0, count: data.count / MemoryLayout<UInt8>.stride))
        }
        
        switch dataArr[StratusModel.ASIPOffset] {
            case StratusModel.StatusASIPID:
                let payload = Data(data[StratusModel.StatusPayloadByteRange])
                stratusData.battery = payload[StratusModel.BatteryByteRange].withUnsafeBytes({ $0.pointee })
                
                notify()
            
            case StratusModel.GPSASIPID:
                let payload = Data(data[StratusModel.GPSPayloadByteRange])
                
                let GPSReciever: UInt8 = payload[StratusModel.GPSReceiverFlagsByteRange].withUnsafeBytes({ $0.pointee })
                stratusData.GPSValid = GPSReciever & StratusModel.GPSFixValidBitValue == StratusModel.GPSFixValidBitValue
                
                stratusData.longitude = payload[StratusModel.LongitudeByteRange].withUnsafeBytes({ $0.pointee })
                stratusData.latitude = payload[StratusModel.LatitudeByteRange].withUnsafeBytes({ $0.pointee })
                
                stratusData.groundSpeed = payload[StratusModel.GroudSpeedByteRange].withUnsafeBytes({ $0.pointee })
                stratusData.altitude = payload[StratusModel.AltitudeMSLByteRange].withUnsafeBytes({ $0.pointee })
                stratusData.verticalSpeed = payload[StratusModel.VerticalSpeedByteRange].withUnsafeBytes({ $0.pointee })
                
                notify()
            
            default:
                break
        }
    }
    
    internal func parseData<T>(type: T.Type, data: [UInt8], offset: Int) -> T {
        let dataPtr = UnsafeRawPointer(data) + offset
        return dataPtr.load(as: type)
    }
    
    // Sets up all sockets or ignores the call if every socket is already setup.
    // If any errors occure while setting up the sockets, pass them up to the UI.
    func setupSockets() throws {
        if statusSocket == nil || gpsSocket == nil {
            statusSocket = try UDPSocket(port: 41501, callback: onRecieveStatus)
            gpsSocket = try UDPSocket(port: 41502, callback: onRecieveStatus)
        }
    }
}
