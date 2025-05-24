//
//  APIConstatns.swift
//  Abhi Babriya
//
//  Created by Abhi Babriya on 24/05/25.
//

import UIKit

var AUTH_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyRGF0YSI6eyJfaWQiOiI1NzMiLCJuYW1lIjoiaGFyc2hpbCIsImNvdW50cnlDb2RlIjoiKzkxIiwiZW1haWwiOiIiLCJwaG9uZSI6OTMxMzU5Nzc5MCwiZGVzY3JpcHRpb24iOiJoZWxsbyIsInRhZ3MiOiIiLCJwcm9maWxlIjoidXBsb2Fkcy9wcm9maWxlLzFiMzFlYTJkLWMzY2UtNGMxYS04OTI4LTAwMDVkNzZhMzNiMCIsIm90cFNlbmRDb3VudCI6MSwibGFzdE90cFNlbmREYXRlIjoiMjAyNS0wMS0wN1QxMToyNTozNi40NjBaIiwiaXNVc2VyVmVyaWZpZWQiOnRydWUsImlzQmFubmVkIjpmYWxzZSwiZGF0ZU9mQmlydGgiOiIxOTkzLTAxLTAxVDAwOjAwOjAwLjAwMFoiLCJsaW5rIjoiIiwiaXNEZWxldGVkIjpmYWxzZSwib2xkUGhvbmUiOm51bGwsInVzZXJUeXBlIjoiVXNlciIsImNyZWF0ZUF0IjoiMjAyNC0wOS0zMFQwNzoyMDoyNC45OTNaIiwidXBkYXRlQXQiOiIyMDI1LTA1LTIxVDA1OjQ3OjA3LjAxNFoiLCJiaW9VcGRhdGUiOiIyMDI1LTA1LTEyVDA1OjMxOjU4LjcyMVoiLCJfX3YiOjAsImlzT3RwVmVyaWZpZWQiOnRydWV9LCJpYXQiOjE3NDc4OTc1MjR9.ElEaPgKGowIvY2m_kqqPG6ON5WR_5XHuc5EK43ldjLQ"

struct APIConstatns {
    
    static let BASE_URL = "http://43.205.16.96:3000/api/v2/"
    static let PROFILE_BASE_URL = "https://d3b13iucq1ptzy.cloudfront.net/"
    static let POST_IMAGE_BASE_URL = "https://d3b13iucq1ptzy.cloudfront.net/uploads/posts/image/"
    
    static let GET_POST = BASE_URL + "post/getPost"
}

struct Images {
    static let userPlaceholder: UIImage = UIImage(systemName: "person.crop.circle")!
    static let LIKE = UIImage(systemName: "heart.fill")!
    static let UNLIKE = UIImage(systemName: "heart")!
}

struct TableViewCell {
    static let PostCell = "PostCell"
}

struct CollectionViewCell {
    static let PostMediaCell = "PostMediaCell"
}
