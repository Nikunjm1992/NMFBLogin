//
//  FBHelper.swift
//  NMFBLogin
//
//  Created by Nikunj Munjiyasara on 20/12/18.
//  Copyright © 2018 Codeappz. All rights reserved.
//

import Foundation
import UIKit

import FacebookCore
import FacebookLogin

let kGraphPathMe = "me"
let kGraphPathMePageLikes = "me/likes"

class FBHelper {
    
    let accessToken: AccessToken
    let networkingManager = APIHelper()
    
    init(accessToken: AccessToken) {
        self.accessToken = accessToken
    }
    
    func requestFacebookUser(completion: @escaping (_ facebookUser: FBUserHelper) -> Void) {
        let graphRequest = GraphRequest(graphPath: kGraphPathMe, parameters: ["fields":"id,email,last_name,first_name,picture"], accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion)
        graphRequest.start { (response: HTTPURLResponse?, result: GraphRequestResult<GraphRequest>) in
            switch result {
            case .success(let graphResponse):
                if let dictionary = graphResponse.dictionaryValue {
                    completion(FBUserHelper(dictionary: dictionary))
                }
                break
            default:
                print("Facebook request user error")
            }
        }
    }
    
    func requestFacebookUserPageLikes() {
        let graphRequest = GraphRequest(graphPath: kGraphPathMePageLikes, parameters: [:], accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion)
        graphRequest.start { (response: HTTPURLResponse?, result: GraphRequestResult<GraphRequest>) in
            print (result)
        }
    }
    
    func requestWallPosts(completion: @escaping (_ posts: [FBPostHelper]) -> Void) {
        let graphRequest = GraphRequest(graphPath: "me/posts", parameters: ["fields":"link,created_time,description,picture,name","limit":"500"], accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion)
        
        graphRequest.start { (response: HTTPURLResponse?, result: GraphRequestResult<GraphRequest>) in
            switch result {
            case .success(let graphResponse):
                if let dictionary = graphResponse.dictionaryValue {
                    self.processWallPostResponse(dictionary: dictionary, posts: [], completion: completion)
                    return
                }
            default: break
            }
            completion([])
        }
    }
    
    private func processWallPostResponse(dictionary: [String: Any?], posts: [FBPostHelper], completion: @escaping (_ posts: [FBPostHelper]) -> Void) {
        var newPosts = [FBPostHelper]()
        if let array = dictionary["data"] as? [[String: String]] {
            for dict in array {
                let fbPost = FBPostHelper(dictionary: dict)
                newPosts.append(fbPost)
            }
        }
        guard let paging = dictionary["paging"] as? [String: String], let next = paging["next"] as String?, next.characters.count > 0 else {
            completion(posts + newPosts)
            return
        }
        networkingManager.get(path: next, params: [:], completion: { (jsonResponse, responseStatus) in
            switch responseStatus {
            case .success:
                guard let jsonResponse = jsonResponse, let dictionary = jsonResponse as? [String: Any] else {
                    completion(posts + newPosts)
                    return
                }
                self.processWallPostResponse(dictionary: dictionary, posts: posts + newPosts, completion: completion)
            case .error(_):
                completion(posts + newPosts)
            }
        })
    }
}
