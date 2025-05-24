//
//  PostModel.swift
//  Abhi Babriya
//
//  Created by Abhi Babriya on 24/05/25.
//

import Foundation

struct PostResponse: Codable {
    let status: String
    let data: [Post]
    let message: String
}

struct Post: Codable {
    let post: PostModel?
}

struct PostModel: Codable {
    let description: String?
    let location: Location?
    var TotalLike: Int?
    var selfLike: Bool?
    let hideLikeCount: Bool?
    let isPin: Bool?
    let _id: String?
    let countRepost: Int?
    let createAt: String?
    var media: [MediaModel]?
    let likeUser: [LikeUser]?
    let shareCount: Int?
    let turnOffComment: Bool?
    let allowDownloadPost: Bool?
    let hashTag: [String]?
    let comments: Int?
    let userId: UserModel?
}

struct Location: Codable {
    let name: String?
    let longitude: Double?
    let latitude: Double?
}

struct MediaModel: Codable {
    let _id: String?
    let type: String?
    let aspectRatio: Double?
    let url: String?
}

struct LikeUser: Codable {
    let userId: UserModel?
}

struct UserModel: Codable {
    let _id: String?
    let email: String?
    let profile: String?
    let name: String?
}
