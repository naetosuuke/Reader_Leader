//
//  FeedData.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/26.
//

import Foundation

struct FeedData : Codable, Equatable{ // 記事imageは保存せず、毎回load時に取得する？
    var title = ""
    var link = "" // URLはStringで保存する
    var pubDate = ""
    var category = ""{
            didSet {
                categoryID = mapCategoryToID(category)
            }
        }
    var categoryID = ""
    var isRead = false
    var isReadLater = false
    var isFavorite = false
  
    private func mapCategoryToID(_ category: String) -> String {
        switch category {
        case "Yahoo!ニュース・トピックス - 主要":
            return "TopPick"
        case "Yahoo!ニュース・トピックス - 国際":
            return "World"
        case "Yahoo!ニュース・トピックス - 国内":
            return "Domestics"
        case "Yahoo!ニュース・トピックス - 経済":
            return "Business"
        case "Yahoo!ニュース・トピックス - エンタメ":
            return "Entertainment"
        case "Yahoo!ニュース・トピックス - スポーツ":
            return "Sports"
        case "Yahoo!ニュース・トピックス - IT":
            return "IT"
        case "Yahoo!ニュース・トピックス - 科学":
            return "Science"
        case "Yahoo!ニュース・トピックス - 地域":
            return "Local"
        default:
            return ""
        }
    }
    
}
