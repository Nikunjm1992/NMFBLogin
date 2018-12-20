//
//  APIHelper.swift
//  NMFBLogin
//
//  Created by Nikunj Munjiyasara on 20/12/18.
//  Copyright © 2018 Codeappz. All rights reserved.
//

import Foundation
import AFNetworking

enum ResponseStatus {
    case success
    case error(error: String)
}

class APIHelper {
    
    func get(path: String, params: [String:String]?, completion: ((_ jsonResponse: Any?, _ responseStatus: ResponseStatus) -> Void)?) {
        let manager = AFHTTPSessionManager(baseURL: nil)
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.get(path, parameters: params, progress: nil, success: { (dataTask, response) in
            if completion != nil {
                completion!(response, .success)
            }
        }) { (dataTask, error) in
            if completion != nil {
                completion!("", .error(error: error.localizedDescription))
            }
        }
    }
}
