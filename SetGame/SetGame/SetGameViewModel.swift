//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Kevin Roebuck on 3/29/22.
//

import MultipeerConnectivity
import SwiftUI

class SetGameViewModel: NSObject, ObservableObject {
    @Published var model: SetGameModel// = SetGameViewModel.createSetGame()
    
    private static let service = "set-game"
    
    var peerId: MCPeerID
    var session: MCSession
    var nearbyServiceAdvertiser: MCNearbyServiceAdvertiser?
    
    override init() {
        self.model = SetGameViewModel.createSetGame()
        
        peerId = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        session.delegate = self
    }
    
    private static func createSetGame() -> SetGameModel {
        SetGameModel()
    }
    
    var missedSetCount: Int = 0
    
    var deck: [Card] {
        model.deck
    }
    
    var displayedDeck: [Card] {
        model.displayedCards
    }
    
    var gameStartTime: Date {
        model.startTime
    }
    
    var isGameFinished: Bool {
        model.isGameFinished
    }
    
    var setAttemped: Bool {
        model.setAttempted
    }
    
    var setSelectionCount: (correct: Int, incorrect: Int) {
        model.setSelectionCount
    }
    
    // MARK: Intent(s)
    
    // TEMP: NOT FINAL
    func pingModel() {
        model.ping()
    }
    
    func resolveSetAttempt() {
        if !isGameFinished {
            model.resolveSetAttempt()
        } else {
            // do something here? display stats page
        }
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func newGame() {
        model = SetGameViewModel.createSetGame()
    }
    
    // user thinks there are no sets and wants to be dealt more cards.
    // if no sets, deal more cards
    // if at least 1 set present, inform user
    func dealCards() {
        if model.howManySetsDisplayed() == 0 {
            model.dealCards()
        } else {
            missedSetCount += 1
            print("There is at least one set present!")
        }
    }
    
    //
    // Multipeer Connectivity
    //
    
    func advertise() {
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: SetGameViewModel.service)
        nearbyServiceAdvertiser?.delegate = self
        nearbyServiceAdvertiser?.startAdvertisingPeer()
    }
    
    func invite() {
        let browser = MCBrowserViewController(serviceType: SetGameViewModel.service, session: session)
        browser.delegate = self
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        window?.rootViewController?.present(browser, animated: true)
    }
    
    
    // Send if chosen cards form a set
    // Not sure if will work. Custom Codable work in 'Card' may be wrong
    func send(set: [Card], to peer: MCPeerID) {
        do {
            let data = try JSONEncoder().encode(set)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension SetGameViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case .connecting:
                print("\(peerId) Connecting...")
            case .connected:
                print("\(peerId) Connected")
            case .notConnected:
                print("\(peerId) Not connected")
            @unknown default:
                print("\(peerId) Unknown state")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(data)
        // decode data
        // remove cards from play (set for other player)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}

extension SetGameViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        invitationHandler(true, session)
    }
}

extension SetGameViewModel: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
}
