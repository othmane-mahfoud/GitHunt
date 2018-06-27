//
//  Repo.swift
//  GitHunt
//
//  Created by Othmane on 6/26/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import Foundation

class Repo {
    
    var repoName : String
    var repoDescription : String
    var repoOwner : String
    var repoOwnerAvatar : String
    var repoStars : Float
    var repoURL : String
    init(name : String, description : String, owner : String, ownerAvatar : String, stars : Float, url: String) {
        repoName = name
        repoDescription = description
        repoOwner = owner
        repoOwnerAvatar = ownerAvatar
        repoStars = stars
        repoURL = url
    }
    
}
