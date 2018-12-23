//
//  Encodable+Dictionary.swift
//  WhiteBoard
//
//  Created by Asad Khan on 12/22/18.
//  Copyright © 2018 Asad Khan. All rights reserved.
//

import Foundation


extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
