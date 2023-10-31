//
//  FeedData.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/26.
//

import Foundation

struct FeedData { // 記事imageは保存せず、毎回load時に取得する？
    var title = ""
    var link = "" // URLはStringで保存する
    var pubDate = ""
    var category = ""
    var isRead = false
    var readLater = false
    var favorite = false
}
