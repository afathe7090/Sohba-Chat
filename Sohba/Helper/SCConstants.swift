//
//  SCConstants.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 01/07/2021.
//

import FirebaseStorage
import UIKit
import FirebaseDatabase

var DBref = Database.database().reference()


public let SCLoginStoryboard = UIStoryboard(name: "Main", bundle: nil)
public let SCUserStoryboard = UIStoryboard(name: "SCUsers", bundle: nil)
public let SCSettingStorboard = UIStoryboard(name: "SCSettings", bundle: nil)
public let SCChatsStoryboard = UIStoryboard(name: "SCChats", bundle: nil)
public let SCChannelStoryboard = UIStoryboard(name: "SCChannels", bundle: nil)



public let defaults = UserDefaults.standard
public let storage =  Storage.storage()



public let kFILEREFERANCE = "gs://onlinechatfirebase.appspot.com"

public let kJPG = ".jpg"
public let kAVATARS = "Avatars/"
public let kNEWSTATUES = "newStatues"
public let kCURRENTUSER = "currentUser"
public let kID = "id"
public let kAVATARLINK = "avatarLink"
public let kEMAIL = "email"
public let kCHATROOMID = "chatRoomId"
public let kSENDERID = "senderId"
public let kSENT = "✔️"
public let kREAD = "✔️✔️"
public let kAOUDIO = "audio"
public let kVIDEO = "video"
public let kTEXT = "text"
public let kLOCATION = "location"
public let kPHOTO = "photo"
public let kDATE = "date"


public let kSTATUES = "status"
public let kREADDATE = "readDate"
public let kAdMINID = "adminId"
public let kMEMBERIDS = "memberIds"

