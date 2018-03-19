//
//  Timeout.swift
//  Stratus
//
//  Created by student on 3/19/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation

enum TimeoutError: Error {
    case timeout
}

class TimeoutTimer {
    private var timer: Timer?
    private var timeoutCallback: ( Error ) -> Void
    private var time: Double
    private var _isRunning: Bool = false
    
    var isRunning: Bool {
        get {
            return _isRunning
        }
    }
    
    init( time: Double, timeoutCallback: @escaping ( Error ) -> Void ) {
        self.timeoutCallback = timeoutCallback
        self.time = time
    }
    
    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
            self.timeoutCallback(TimeoutError.timeout)
        }
        
        _isRunning = true;
    }
    
    func stop() {
        timer?.invalidate()
        _isRunning = false;
    }
}
