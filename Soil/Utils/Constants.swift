//
//  Constants.swift
//  Soil
//
//  Created by dykoon on 2021/11/09.
//

import Firebase

typealias FirestoreCompletion = (Error?) -> Void

let COLLECTION_USERS = Firestore.firestore().collection("users")
