//
//  File.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/11/06.
//

import UIKit

class RSSFeedHandler {
    
    func checkDuplicationAndStoreDatas (fetchedFeedDatas: [FeedData], storedFeedDatas: [FeedData]) -> [FeedData] {
        var checkedFeedDatas:[FeedData] = []
        var mySet = Set<String>() //Setを用いて、入手済みの記事を重複して取得しないようにする (chatGPTで生成)https://docs.swift.org/swift-book/documentation/the-swift-programming-language/collectiontypes/#Sets
        for item in storedFeedDatas {
            mySet.insert(item.title)
        }
        for item in fetchedFeedDatas {
            if mySet.insert(item.title).inserted {
                checkedFeedDatas.append(item)
            }
        }
        return checkedFeedDatas
    }
}
