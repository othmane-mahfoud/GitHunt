//
//  RepoService.swift
//  GitHunt
//
//  Created by Othmane on 6/26/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import Foundation
import Moya

enum RepoService {
    case showRepos(q: String, sort: String, order: String)
}

extension RepoService : TargetType {
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    var path : String {
        switch self {
        case .showRepos:
            return "/search/repositories"
        }
    }
    
    var method : Moya.Method {
        switch self {
        case .showRepos:
            return .get
        }
    }
    
    var task : Task {
        switch self {
        case .showRepos(let q, let sort, let order):
            return .requestParameters(parameters: ["q": q, "sort": sort, "order": order], encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData : Data {
        switch self {
        case .showRepos:
            return Data()
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}


