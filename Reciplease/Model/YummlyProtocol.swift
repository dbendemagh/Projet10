//
//  NetworkRequest.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 19/02/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import Alamofire

protocol YummlyProtocol {
    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void)
}
