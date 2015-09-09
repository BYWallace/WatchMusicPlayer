//
//  InterfaceController.swift
//  PlayThatSong WatchKit Extension
//
//  Created by Brett Wallace on 9/4/15.
//  Copyright (c) 2015 Brett Wallace. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet weak var songTitleLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    // MARK: - IBActions
    
    @IBAction func previousSongButtonPressed() {
    }
    
    @IBAction func nextSongButtonPressed() {
    }
    
    @IBAction func playSongButtonPressed() {
    }
}
