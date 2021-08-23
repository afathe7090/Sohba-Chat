//
//  SCCollectionReferance.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 01/07/2021.
//

import Foundation
import Firebase

enum SCColletionReferance: String{
    case User
    case Chat
    case Message
    case Typing
    case channel
}


func FirestoreReference(_ collectionReference: SCColletionReferance) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}

