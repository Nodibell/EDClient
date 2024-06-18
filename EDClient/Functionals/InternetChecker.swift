//
//  InternetConnectivityChecker.swift
//  EDClient
//
//  Created by Oleksii Chumak on 14.06.2024.
//

import Foundation
import Network

class InternetChecker {
    static let shared = InternetChecker()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    private var isMonitoringStarted = false
    private var isConnected: Bool = false
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        guard !isMonitoringStarted else { return }
        isMonitoringStarted = true
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    func checkConnectivity() -> Bool {
        return isConnected
    }
}


