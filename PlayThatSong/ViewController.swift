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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleRequest:"), name: "WatchKitDidMakeRequest", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func playButtonPressed(sender: UIButton) {
        self.playMusic()
        self.updateUI()
    }
    
    
    @IBAction func playPreviousButtonPressed(sender: AnyObject) {
        
        if currentSongIndex > 0 {
            self.audioQueuePlayer.pause()
            self.audioQueuePlayer.seekToTime(kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            let temporaryNowPlayIndex = currentSongIndex
            let temporaryPlayList = self.createSongs()
            self.audioQueuePlayer.removeAllItems()
            for var index = temporaryNowPlayIndex - 1; index < temporaryPlayList.count; index++ {
                self.audioQueuePlayer.insertItem(temporaryPlayList[index] as! AVPlayerItem, afterItem: nil)
            }
            self.currentSongIndex = temporaryNowPlayIndex - 1
            self.audioQueuePlayer.seekToTime(kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            self.audioQueuePlayer.play()
        }
        self.updateUI()
    }
    
    @IBAction func playNextButtonPressed(sender: AnyObject) {
        self.audioQueuePlayer.advanceToNextItem()
        self.currentSongIndex = self.currentSongIndex + 1
        self.updateUI()
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
        
        if audioQueuePlayer.rate > 0 && audioQueuePlayer.error == nil {
            self.audioQueuePlayer.pause()
        } else if currentSongIndex == nil {
            self.audioQueuePlayer.play()
            self.currentSongIndex = 0
        } else {
            self.audioQueuePlayer.play()
        }
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
        self.currentSongIndex = self.currentSongIndex + 1
        self.updateUI()
    }
    
    // MARK: - UIUpdate Helpers
    
    func updateUI() {
        self.currentSongLabel.text = currentSongName()
        
        if audioQueuePlayer.rate > 0 && audioQueuePlayer.error == nil {
            self.playButton.setTitle("Pause", forState: UIControlState.Normal)
        } else {
            self.playButton.setTitle("Play", forState: UIControlState.Normal)
        }
    }
    
    func currentSongName() -> String {
        var currentSong: String
        
        if currentSongIndex == 0 {
            currentSong = "Classical Solitude"
        } else if currentSongIndex == 1 {
            currentSong = "The Knolls of Doldesh"
        } else if currentSongIndex == 2 {
            currentSong = "Sending my Signal"
        } else {
            currentSong = "No Song Playing"
            println("Something went wrong")
        }
        
        return currentSong
    }
    
    // MARK: - WatchKit Notificaiton
    
    func handleRequest(notification: NSNotification) {
        let watchKitInfo = notification.object! as! WatchKitInfo
        
        if watchKitInfo.playerRequest != nil {
            let requestAction: String = watchKitInfo.playerRequest!
            
            switch requestAction {
            case "Play":
                self.playMusic()
            case "Next":
                self.playNextButtonPressed(self)
            case "Previous":
                self.playPreviousButtonPressed(self)
            default:
                println("default value printed, something went wrong")
            }
            
            let currentSongDictionary = ["currentSong": currentSongName()]
            watchKitInfo.replyBlock(currentSongDictionary)
            
            self.updateUI()
        }
    }
}

