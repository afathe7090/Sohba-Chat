//
//  SCFileStore.swift
//  Sohba
//
//  Created by Ahmed Fathy on 06/07/2021.
//

import Foundation
import UIKit
import FirebaseStorage
import ProgressHUD


class FileStorage {
    
    //MARK: -  Images
    
    
    
    //MARK: -  Upload
    class func upLoadImage(_ image: UIImage , directory: String , completion: @escaping (_ doucomentLink: String?)-> Void){
        
        //1. creat folder on firestore
        
        let storageRef = storage.reference(forURL: kFILEREFERANCE).child(directory)
        //2. convert Image To Data For save
        
        let imagesData = image.jpegData(compressionQuality: 0.8)
        //3. put the image to the filestore
        
        var task: StorageUploadTask!
        
        task = storageRef.putData(imagesData!, metadata: nil, completion: { metaData, error in
            
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil{
                print("Error Upload Image \(error!.localizedDescription)")
                return
            }
            
            
            storageRef.downloadURL {url, error in
                guard let downloadURL = url else{
                    completion(nil)
                    return
                }
                
                completion(downloadURL.absoluteString)
            }
        })
        //4. Observer percent Upload
        
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
        
    }
    
    
    
    
    //MARK: -  Download Image
    
    class func downloadImage(imageURL: String ,completion: @escaping(_ image: UIImage?)->Void){
        
        let imageFileName = fileNameFrom(fileURL: imageURL)
        
        if fileExistAtPath(path: imageFileName){
            
            // get it locally
            if let constantsOfFile = UIImage(contentsOfFile: fileInDocumentsDirecutury(fileName: imageFileName)){
                completion(constantsOfFile)
            }else{
                print("could not convert Locally")
                completion(UIImage(named: "avatar")!)
            }
            
            
        }else {
            //Download From Firebase
            
            if imageURL != ""{
                
                let documentUrl = URL(string: imageURL)
                let downloadQueue = DispatchQueue (label: "imageDownloadQueue")
                
                downloadQueue.async {
                    let data = NSData(contentsOf: documentUrl!)
                    
                    if data != nil {
                        
                        //save locally
                        FileStorage.saveFileLocally(fileData: data! , fileName: imageFileName)
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                    }else {
                        print("Image not found in dataBase")
                        completion(nil)
                    }
                }
            }
            
        }
    }
    
    
    
    
    //MARK: - Upload Video
    
    
    class func upLoadVideo(_ video: NSData , directory: String , completion: @escaping (_ videoLink: String?)-> Void){
        
        //1. creat folder on firestore
        
        let storageRef = storage.reference(forURL: kFILEREFERANCE).child(directory)        
        
        //3. put the image to the filestore
        
        var task: StorageUploadTask!
        
        task = storageRef.putData(video as Data, metadata: nil, completion: { metaData, error in
            
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil{
                print("Error Upload Image \(error!.localizedDescription)")
                return
            }
            
            
            storageRef.downloadURL {url, error in
                guard let downloadURL = url else{
                    completion(nil)
                    return
                }
                
                completion(downloadURL.absoluteString)
            }
        })
        //4. Observer percent Upload
        
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
        
    }
    
    
    
    
    //MARK: - Download Video
    
    class func downloadVideo(videoUrl: String ,completion: @escaping(_ isReadyToPlay: Bool,_ videoFileName: String )->Void){
        
        let videoFileName = fileNameFrom(fileURL: videoUrl)  + ".mov"
        if fileExistAtPath(path: videoFileName){
            
            completion(true, videoFileName)
        
    
        }else {
            //Download From Firebase
            
            if videoUrl != ""{
                
                let documentUrl = URL(string: videoUrl)
                let downloadQueue = DispatchQueue (label: "imageDownloadQueue")
                
                downloadQueue.async {
                    let data = NSData(contentsOf: documentUrl!)
                    
                    if data != nil {
                        
                        //save locally
                        FileStorage.saveFileLocally(fileData: data! , fileName: videoFileName)
                        DispatchQueue.main.async {
                            completion(true, videoFileName)
                        }
                    }else {
                        print("Viseo not found in dataBase")
                    }
                }
                
            }
            
        }
    }
    
    
    
    
    //MARK: - Recorder
    
    
    
    class func uploadAudio(_ audioFileName: String , directory: String , completion: @escaping (_ audioLink: String?)-> Void){
        
        //1. creat folder on firestore
        
        let fileName = audioFileName + ".m4a"
        let storageRef = storage.reference(forURL: kFILEREFERANCE).child(directory)
        
        //3. put the image to the filestore
        
        var task: StorageUploadTask!
        
        if fileExistAtPath(path: fileName) {
            
            if let audioData = NSData(contentsOfFile: fileInDocumentsDirecutury(fileName: fileName)) {
                
                task = storageRef.putData(audioData as Data, metadata: nil, completion: { metaData, error in
                    
                    task.removeAllObservers()
                    ProgressHUD.dismiss()
                    
                    if error != nil{
                        print("Error Upload Audio \(error!.localizedDescription)")
                        return
                    }
                    
                    
                    storageRef.downloadURL {url, error in
                        guard let downloadURL = url else{
                            completion(nil)
                            return
                        }
                        
                        completion(downloadURL.absoluteString)
                    }
                })
                //4. Observer percent Upload
                
                task.observe(StorageTaskStatus.progress) { snapshot in
                    let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
                    ProgressHUD.showProgress(CGFloat(progress))
                }
                
            }
        }else{
            print("Noting to upload , or file does not exist")
        }
        
        
    }
    
    
    
    
    
    
    
    
    class func downloadAudio(audioUrl: String ,completion: @escaping(_ audioFileName: String )->Void){
        
        let audioFilename = fileNameFrom(fileURL: audioUrl)  + ".m4a"
        if fileExistAtPath(path: audioFilename){
            
            completion(audioFilename)
        
    
        }else {
            //Download From Firebase
            
            if audioUrl != ""{
                
                let documentUrl = URL(string: audioUrl)
                let downloadQueue = DispatchQueue (label: "AudioDownloadQueue")
                
                downloadQueue.async {
                    let data = NSData(contentsOf: documentUrl!)
                    
                    if data != nil {
                        
                        //save locally
                        FileStorage.saveFileLocally(fileData: data! , fileName: audioFilename)
                        DispatchQueue.main.async {
                            completion(audioFilename)
                        }
                    }else {
                        print("Viseo not found in dataBase")
                    }
                }
                
            }
            
        }
    }
    
    
    
    
    
    
    //MARK: -  helper Function
    
    
    
    //MARK: - Save User Locally
    class func saveFileLocally(fileData: NSData, fileName: String){
        let docURl = getDocumentURL().appendingPathComponent(fileName ,isDirectory: false)
        fileData.write(to: docURl, atomically: true)
    }
    
}



//MARK: -  Helper Function


func getDocumentURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}



func fileInDocumentsDirecutury(fileName: String) ->String {
    return getDocumentURL().appendingPathComponent(fileName).path
}


func fileExistAtPath(path: String) ->Bool{
    
    return FileManager.default.fileExists(atPath: fileInDocumentsDirecutury(fileName: path))
}
