//
//  ViewController.swift
//  PitchModulator
//
//  Created by Anisha Rafik on 21/03/16.
//  Copyright © 2016 AlTech. All rights reserved.
//

import UIKit
import AVFoundation
//import PlaySoundsViewController.swift

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        
        print("record button pressed")
        recordingLabel.text="Recording In Progress..."
        stopRecordingButton.enabled=true
        recordButton.enabled=false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }

    @IBAction func stopRecording(sender: AnyObject) {
        
        print("Stop Recording")
        recordingLabel.text="Finished Recording"
        recordButton.enabled=true
        stopRecordingButton.enabled=false
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    override func viewWillAppear(animated: Bool) {
       // print("View will apper")
        stopRecordingButton.enabled=false
        recordingLabel.text="Tap To Record"
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Audio Recorder Finished Recording..")
        if(flag)
        {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        }
        else
        {
            print("Saving of the recording failed")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
        let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
        let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudio = recordedAudioURL
        }
    }
}

