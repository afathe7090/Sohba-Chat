//
//  AudioRecorder.swift
//  Sohba
//
//  Created by Ahmed Fathy on 16/07/2021.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject , AVAudioRecorderDelegate {
    
    
    var recorderSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var isAudioRecordedGrented: Bool!
    
    static let shared = AudioRecorder()
    
    private override init() {
        super.init()
        
        checkRecorderPermission()
        
    }
    
    
    
    func checkRecorderPermission(){
        
        switch AVAudioSession.sharedInstance().recordPermission{
            
        case .granted:
            
            isAudioRecordedGrented = true
            
        case .denied:
            
            isAudioRecordedGrented = false
            
            case .undetermined:
            
            AVAudioSession.sharedInstance().requestRecordPermission { isAllowed in
                
                self.isAudioRecordedGrented  = isAllowed
            }
            
        default :
            break
        }
        
    }
    
    
    func setUpRecourder(){
        
        if isAudioRecordedGrented {
            recorderSession = AVAudioSession.sharedInstance()
            
            do{
                
                try recorderSession.setCategory(.playAndRecord , mode: .default)
                try recorderSession.setActive(true)
                
            }catch{
                
                print("Error Setting Up Recording", error.localizedDescription)
            }
        }
        
    }
    
    func startRecording(fileName: String){
        
        let audioFileName = getDocumentURL().appendingPathComponent(fileName + ".m4a" , isDirectory: false)
        
        let settings = [
            
            AVFormatIDKey : Int (kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1 ,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do{
                
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        }catch{
            
            print("Error Recording", error.localizedDescription)
            finishRecourding()
        }
        
    }
    
    
    
    func finishRecourding(){
        
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
        }
    }
    
}
