//
//  ViewController.swift
//  PlayThatSong
//
//  Created by Brett Wallace on 9/4/15.
//  Copyright (c) 2015 Brett Wallace. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentSongLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions
    
    @IBAction func playButtonPressed(sender: UIButton) {
    }
    
    
    @IBAction func playPreviousButtonPressed(sender: UIButton) {
    }
    
    @IBAction func playNextButtonPressed(sender: UIButton) {
    }
}

