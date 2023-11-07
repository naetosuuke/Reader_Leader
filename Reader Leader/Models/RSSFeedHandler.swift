//
//  File.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/11/06.
//

import UIKit

class RSSFeedHandler {
    
    func checkDuplication (fetchedFeedDatas: [FeedData], storedFeedDatas: [FeedData]) -> [FeedData] {
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
    
    func filterFeedData (storedFeedDatas: [FeedData]) -> [FeedData] {
        var filteredFeedDatas: [FeedData] = storedFeedDatas
        let category = UserDefaults.standard.string(forKey: "chosenCategoryForListView")!
    //ソート用キーワード(categoryID)を取得
        if category != "All" { //ソートする
            switch category {
            case "Unread" : filteredFeedDatas = storedFeedDatas.filter{ (feedData) in
                feedData.isRead == false
            }
            case "Favorite" : filteredFeedDatas = storedFeedDatas.filter{ (feedData) in
                feedData.isFavorite == true
            }
            case "Read Later": filteredFeedDatas = storedFeedDatas.filter{ (feedData) in
                feedData.isReadLater == true
            }
            default :  filteredFeedDatas = storedFeedDatas.filter{ (feedData) in
                feedData.categoryID == category
            }
            }
        }
        return filteredFeedDatas
    }
    
    
    
}


