//
//  Preferences.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/26.
//

import Foundation

struct Preferences {
    //　UserDefaultのキーワードに該当するプロパティがnilだったら(初回起動時) これらのプロパティを付与する。
    var rssListType = "table style"
    var rssReloadInterval = "30 minutes"
    var characterSize = "mid"
//    var darkmode = "light"
}
