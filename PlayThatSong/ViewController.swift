//
//  ViewController.swift
//  PlayThatSong
//
//  Created by Brett Wallace on 9/4/15.
//  Copyright (c) 2015 Brett Wallace. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentSongLabel: UILabel!
    
    var audioSession: AVAudioSession!
//    var audioPlayer: AVAudioPlayer!
    var audioQueuePlayer: AVQueuePlayer!
    var currentSongIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureAudioSession()
//        self.configureAudioPlayer()
        self.configureAudioQueuePlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions
    
    @IBAction func playButtonPressed(sender: UIButton) {
        self.playMusic()
    }
    
    
    @IBAction func playPreviousButtonPressed(sender: UIButton) {
    }
    
    @IBAction func playNextButtonPressed(sender: UIButton) {
        self.audioQueuePlayer.advanceToNextItem()
        self.currentSongIndex += 1
    }
    
    // MARK: - Audio
    
    func configureAudioSession() {
        self.audioSession = AVAudioSession.sharedInstance()
        
        var categoryError: NSError?
        var activeError: NSError?
        
        self.audioSession.setCategory(AVAudioSessionCategoryPlayback, error: &categoryError)
        println("error \(categoryError)")
        var success = self.audioSession.setActive(true, error: &activeError)
            if !success {
            println("Error making audio session active \(activeError)")
        }
    }
    
//    func configureAudioPlayer() {
//        var songPath = NSBundle.mainBundle().pathForResource("Open Source - Sending My Signal", ofType: "mp3")
//        var songURL = NSURL.fileURLWithPath(songPath!)
//        println("songURL: \(songURL)")
//        
//        var songError: NSError?
//        self.audioPlayer = AVAudioPlayer(contentsOfURL: songURL, error: &songError)
//        println("song error: \(songError)")
//        self.audioPlayer.numberOfLoops = 0
//    }
    
    func configureAudioQueuePlayer() {
        let songs = createSongs()
        self.audioQueuePlayer = AVQueuePlayer(items: songs)
        
        for var songIndex = 0; songIndex < songs.count; songIndex++ {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "songEnded:", name: AVPlayerItemDidPlayToEndTimeNotification, object: songs[songIndex])
        }
    }
    
    func playMusic() {
        // Implement to use the audioplayer we replaced this with the audio queue player
//        self.audioPlayer.prepareToPlay()
//        self.audioPlayer.play()
        
        self.audioQueuePlayer.play()
        self.currentSongIndex = 0
    }
    
    func createSongs() -> [AnyObject] {
        let firstSongPath = NSBundle.mainBundle().pathForResource("CLASSICAL SOLITUDE", ofType: "wav")
        let secondSongPath = NSBundle.mainBundle().pathForResource("Timothy Pinkham - The Knolls of Doldesh", ofType: "mp3")
        let thirdSongPath = NSBundle.mainBundle().pathForResource("Open Source - Sending My Signal", ofType: "mp3")
        
        let firstSongURL = NSURL.fileURLWithPath(firstSongPath!)
        let secondSongURL = NSURL.fileURLWithPath(secondSongPath!)
        let thirdSongURL = NSURL.fileURLWithPath(thirdSongPath!)
        
        let firstPlayerItem = AVPlayerItem(URL: firstSongURL)
        let secondPlayerItem = AVPlayerItem(URL: secondSongURL)
        let thirdPlayerItem = AVPlayerItem(URL: thirdSongURL)
        
        let songs: [AnyObject] = [firstPlayerItem, secondPlayerItem, thirdPlayerItem]
        
        return songs
    }
    
    // MARK: - Audio Notification
    
    func songEnded(notification: NSNotification) {
        self.currentSongIndex += 1
    }
}

