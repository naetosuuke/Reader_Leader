//
//  API.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/26.
//
//
//

import Foundation

class RSSFeedParser: NSObject, XMLParserDelegate {
    
    var currentString = ""
    var feedDatas = [FeedData]()
    var feedData: FeedData?
    
    
    func parseXML(url: URL) {
        self.feedDatas = []
        guard let parser = XMLParser(contentsOf: url) else { return } // MARK: - 同期通信を使用することに紫エラーが起きるが、バグ？もしくは非同期に変える？　https://halzoblog.com/error-bug-diary/20221229-2/
        parser.delegate = self
        parser.parse() //Parseの実行
    }
    
    //開始タグが見つかった時に呼ばれるメソッド
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        self.currentString = "" // 現在処理中のXML要素を保存
        if elementName == "item" {
            self.feedData = FeedData()
            }
        }
    
    //テキストデータが見つかった時に呼ばれるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentString += string
    }
    
    //終了タグが見つかった時に呼ばれるメソッド
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "title": self.feedData?.title = currentString
        case "link": self.feedData?.link = currentString
        case "pubDate": self.feedData?.pubDate = currentString
        case "item": self.feedDatas.append(self.feedData!)
        default: break
        }
    }
    
    // パースが完了した時に呼ばれるメソッド
    func parserDidEndDocument(_ parser: XMLParser) {
        // パースが完了したときにデータを使用するか、出力するなどの処理をここに追加できます。
        self.currentString = ""
    }
    
    
}
