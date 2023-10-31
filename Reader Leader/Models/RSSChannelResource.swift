//
//  RSSChannelResource.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/31.
//

import Foundation

struct RSSChannelResource {
    struct rssChannelResourceProperty {
        let category = ""
        let url = ""
        let isSubscribed = false
    }
    
    let rssChannelResource = ["topPick", "domestics", "world", "business", "entertainment", "sports", "it", "science", "local"]
    let rssChannelResourceDictionary = ["topPick" : "https://news.yahoo.co.jp/rss/topics/top-picks.xml",
                            "domestics" : "https://news.yahoo.co.jp/rss/topics/domestic.xml",
                            "world" : "https://news.yahoo.co.jp/rss/topics/world.xml",
                            "business" : "https://news.yahoo.co.jp/rss/topics/business.xml",
                            "entertainment" : "https://news.yahoo.co.jp/rss/topics/entertainment.xml",
                            "sports" : "https://news.yahoo.co.jp/rss/topics/sports.xml",
                            "it" : "https://news.yahoo.co.jp/rss/topics/it.xml",
                            "science" : "https://news.yahoo.co.jp/rss/topics/science.xml",
                            "local" : "https://news.yahoo.co.jp/rss/topics/local.xml"]
}
