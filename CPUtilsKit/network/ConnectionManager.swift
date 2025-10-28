//
//  ConnectionStatus.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

internal import Network
internal import Logging

public enum ConnectionStatus {
    case connected
    case disconnected
}

// TODO: redo with async/await and continuation syntax
public protocol Connectionable: AnyObject {
    func startMonitoring(
        completion: (() -> Void)?
    )
    
    func stopMonitoring()
    
    func onConnectionStatusChanged(
        completion: @escaping (_ status: ConnectionStatus) -> Void
    )
    
    var isReachable: Bool { get }
    var coverAction: (() -> Void)? { set get }
}

// HERE I use singleton with small "s" pattern to allow custom implementations of connection manager if needed

public final class ConnectionManager {
    public static let shared: Connectionable = ConnectionManager()
    
    // MARK: - Private
    
    private var didChangePathStatus: ((ConnectionStatus) -> Void)?
    
    private var pathMonitor: NWPathMonitor!
    
    private(set) var pathStatus: NWPath.Status = .requiresConnection {
        didSet {
            updateStatus()
        }
    }
    
    private var startCompletion: (() -> Void)?
    
    private func updateStatus() {
        logConnection(isReachable)
        didChangePathStatus?( isReachable ? .connected : .disconnected)
    }
    
    private func didChangeConnectionStatus(_ sender: NWPath) {
        defer { startCompletion = nil }
        pathStatus = sender.status
        startCompletion?()
    }
    
    private func logConnection(_ isReachable: Bool) {
        if !isReachable { coverAction?() }
        
        logger.info(.init(stringLiteral: "Network status: \(isReachable ? "Connected" : "Not Connected")"))
    }
    
    // MARK: - Public
    
    public var coverAction: (() -> Void)?
    
    public init() {
        self.configure()
    }
    
    public func configure() {
        pathMonitor = NWPathMonitor()
        pathStatus = .requiresConnection
        pathMonitor.pathUpdateHandler = didChangeConnectionStatus
    }
}

extension ConnectionManager: Connectionable {
    public var isReachable: Bool {
        [NWPath.Status.satisfied, .requiresConnection].contains(pathStatus)
    }
    
    public func startMonitoring(completion: (() -> Void)? = nil) {
        startCompletion = completion
        pathMonitor.start(queue: .main)
    }
    
    public func stopMonitoring() {
        pathMonitor.cancel()
    }
    
    public func onConnectionStatusChanged(
        completion: @escaping (_ status: ConnectionStatus) -> Void
    ) {
        didChangePathStatus = completion
    }
}
