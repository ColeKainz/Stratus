//
//  UDPSocket.swift
//  Stratus
//
//  This class creates a UDP socket and passes all of the its recieved data
//  through a given callback function.
//
//  Created by student on 2/23/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class UDPSocket: NSObject, GCDAsyncUdpSocketDelegate {
    private var dataCallback: ( Data ) -> Void //  The function that reacts to the socket's recieved data.
    private var errorCallback: ( Error ) -> Void
    private var timeoutTimer: TimeoutTimer
    
    //  @port The port the socket will listen on.
    //  @callback The function to call when data is recieved.
    init?( port: UInt16, dataCallback: @escaping ( Data ) -> Void, errorCallback: @escaping ( Error ) -> Void ) {
        self.dataCallback = dataCallback
        self.errorCallback = errorCallback
        timeoutTimer = TimeoutTimer(time: 10, timeoutCallback: errorCallback)
        
        super.init()
        
        let socket = GCDAsyncUdpSocket( delegate: self, delegateQueue: DispatchQueue.main )

        do {
            try socket.bind( toPort: port )
            try socket.beginReceiving()
            
            timeoutTimer.start()
        } catch {
            errorCallback( error )
            timeoutTimer.stop()
            
            return nil
        }
    }
    
    // Sends recived data through the callback.
    internal func udpSocket( _ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any? ) {
        if timeoutTimer.isRunning {
            timeoutTimer.start()
        }
        dataCallback( data )
    }
    
    internal func udpSocket( _ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error? ) {
        timeoutTimer.stop()
        errorCallback( error.unsafelyUnwrapped )
    }
    
    func refresh() {
        timeoutTimer.start()
    }
}

