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

class YummlySessionFake: YummlyProtocol {
    private let fakeResponse: FakeResponse
    
    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }
    
    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        let httpResponse = fakeResponse.httpResponse
        let data = fakeResponse.data
        let error = fakeResponse.error
        let result: Result<Any> // Alamofire Result
        
        let urlRequest = URLRequest(url: URL(string: "www.test.fr")!)
        
        if let error = error {
            result = .failure(error)
        } else {
            result = .success("ok")
        }
        
        completionHandler(DataResponse(request: urlRequest, response: httpResponse, data: data, result: result))
    }
}
