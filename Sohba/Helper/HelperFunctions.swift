//
//  Helper Function .swift
//  Sohba
//
//  Created by Ahmed Fathy on 06/07/2021.
//

import Foundation
import AVFoundation
import UIKit

func fileNameFrom(fileURL: String)->String {
    
    let name = fileURL.components(separatedBy: "_").last
    let name1 = name?.components(separatedBy: "?").first
    let name2 = name1?.components(separatedBy: ".").first
    
    return name2!
}



func timeElapsed(_ date: Date)->String {
    
    let seconds = Date().timeIntervalSince(date)
    var elapsed = ""
    
    
    if seconds < 60 {
        
        elapsed = "Just now"
        
    }else if seconds < 60 * 60 {
        
        let minutes = Int(seconds / 60)
        let minText = minutes > 1 ? "mins":"min"
        elapsed = "\(minutes) \(minText)"
        
        
    }else if  seconds < 24 * 60 * 60 {
        
        let hours = Int(seconds / (60 * 60))
        let hourText = hours > 1 ? " hours" : " hour"
        elapsed = "\(hours)\(hourText)"
        
        
    }else{
        elapsed = "\(date.longDate())"
    }
    
    return elapsed
}


extension Date {
    
    func longDate() ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func stringDate() ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }
    
    func time() ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, to date: Date )->Float {
        
        let currentCalendar = Calendar.current
        
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: date) else {return 0}
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: self) else {return 0}
        
        return Float(end - start)
        
        
        
    }
    
    
}


func videoThumbnail(videoURL: URL) -> UIImage {
    do {
        let asset = AVURLAsset(url: videoURL, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        return thumbnail
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return UIImage(named: "photoPlaceholder")!
    }
}
