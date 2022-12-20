//
//  APIManager.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/19.
//

import Foundation

class APIManager {
    
}

extension Encodable {
    func toData(using encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}

extension Data {
    func toObject<T>(resClass: T.Type) throws -> T? where T: Decodable {
        let res = try JSONDecoder().decode(resClass, from: self)
        return res
    }
}
