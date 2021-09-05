//
//  Photo.swift
//  jsonplaceholder_test_ios
//
//  Created by Andrey Leganov on 9/4/21.
//

import Foundation

struct Photo: Codable {
    var albumId: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
}
