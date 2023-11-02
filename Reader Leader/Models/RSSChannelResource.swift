//
//  RSSChannelResource.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/31.
//

import Foundation

struct RSSChannelResource {
    let rssChannelResource = ["TopPick", "Domestics", "World", "Business", "Entertainment", "Sports", "IT", "Science", "Local"] // リソースを置く
    let rssChannelResourceDictionary = ["TopPick" : "https://news.yahoo.co.jp/rss/topics/top-picks.xml",
                            "Domestics" : "https://news.yahoo.co.jp/rss/topics/domestic.xml",
                            "World" : "https://news.yahoo.co.jp/rss/topics/world.xml",
                            "Business" : "https://news.yahoo.co.jp/rss/topics/business.xml",
                            "Entertainment" : "https://news.yahoo.co.jp/rss/topics/entertainment.xml",
                            "Sports" : "https://news.yahoo.co.jp/rss/topics/sports.xml",
                            "IT" : "https://news.yahoo.co.jp/rss/topics/it.xml",
                            "Science" : "https://news.yahoo.co.jp/rss/topics/science.xml",
                            "Local" : "https://news.yahoo.co.jp/rss/topics/local.xml"]
}

struct RSSChannelResourceProperty {
        let category = ""
        let url = ""
        let isSubscribed = false
}
