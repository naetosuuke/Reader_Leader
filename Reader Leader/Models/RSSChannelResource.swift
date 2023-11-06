//
//  RSSChannelResource.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/31.
//

import Foundation

struct RSSChannelResource {
    
    let rssChannelResource = ["TopPick", "Domestics", "World", "Business", "Entertainment", "Sports", "IT", "Science", "Local"] // リソースを置く
//    
//    var rssChannelResourceDictionary: String { // RSSから撮ったカテゴリ名をIDとして置き換え
//        switch rssChannelResource[] {
//        case "Yahoo!ニュース・トピックス - 主要":
//            return "https://news.yahoo.co.jp/rss/topics/top-picks.xml"
//        case "Yahoo!ニュース・トピックス - 国際":
//            return "https://news.yahoo.co.jp/rss/topics/world.xml"
//        case "Yahoo!ニュース・トピックス - 国内":
//            return "https://news.yahoo.co.jp/rss/topics/domestic.xml"
//        case "Yahoo!ニュース・トピックス - 経済":
//            return "https://news.yahoo.co.jp/rss/topics/business.xml"
//        case "Yahoo!ニュース・トピックス - エンタメ":
//            return "https://news.yahoo.co.jp/rss/topics/entertainment.xml"
//        case "Yahoo!ニュース・トピックス - スポーツ":
//            return "https://news.yahoo.co.jp/rss/topics/sports.xml"
//        case "Yahoo!ニュース・トピックス - IT":
//            return "https://news.yahoo.co.jp/rss/topics/it.xml"
//        case "Yahoo!ニュース・トピックス - 科学":
//            return "https://news.yahoo.co.jp/rss/topics/science.xml"
//        case "Yahoo!ニュース・トピックス - 地域":
//            return "https://news.yahoo.co.jp/rss/topics/local.xml"
//        default:
//            return ""
//        }
//    }
}

struct RSSChannelResourceProperty {
        let category = ""
        let url = ""
        let isSubscribed = false
}
