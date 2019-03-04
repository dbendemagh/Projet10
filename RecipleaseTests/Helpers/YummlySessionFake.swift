//
//  YummlySessionFake.swift
//  RecipleaseTests
//
//  Created by Daniel BENDEMAGH on 03/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import Alamofire
@testable import Reciplease

class YummlySessionFake: YummlySession {
    
    private let fakeResponse: FakeResponse
    
    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }
    
    override func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        let httpResponse = fakeResponse.response
        let data = fakeResponse.data
        let error = fakeResponse.error
        
        let result = Request.serializeResponseJSON(options: .allowFragments, response: httpResponse, data: data, error: error)
        
        let urlRequest = URLRequest(url: URL(string: "test")!)
        
        completionHandler(DataResponse(request: urlRequest, response: httpResponse, data: data, result: result))
    }
}
