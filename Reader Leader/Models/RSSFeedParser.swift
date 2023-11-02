//
//  API.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/26.
//

import Foundation

class RSSFeedParser: NSObject, XMLParserDelegate { // ParserをイニシャライズするクラスにはXMLParserDelegateの適用が必要で、そのためにクラスへNSObject型を適用している　（ChatGPT調べ）
    
    // MARK: - Properties
    var currentString = "" // elementに紐づく値を保存するためのプロパティ　ストアドじゃなくてもいいかもしれない
    var feedDatas = [FeedData]() // TODO: なぜインスタンス化させている？理由を調べる
    var feedData: FeedData?
    var isInsideChannel = false // パース時、カテゴリと記事名が同じtitleという要素で見つかるので、その仕分け用に設定
    var parsingCategory = "" // パース中のカテゴリ名を格納するプロパティ
    
    // MARK: - Methods
    func downloadAndParseXML(channelLinks: [String]) async -> [FeedData] {  // MARK: chatGPTによるリファクタ VC上でGroupDispatchを使って非同期処理を行なっていたが、async/awaitを使って書き換え
        var fetchedFeedDatas: [FeedData] = []
        for channelLink in channelLinks {
            guard let cL = URL(string: channelLink) else {
                print("Invalid URL: \(channelLink)")
                continue
            }
            do { // エラーの補足を行う
                let data = try await URLSession.shared.data(from: cL).0 //awaitで非同期操作の完了を待つ　この0は戻り値が(Data, URLResponse)と2つあるので、0番目(先頭)の戻り値を適用する　という意味
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
                fetchedFeedDatas.append(contentsOf: self.feedDatas)
            } catch {
                print("Failed to fetch data for URL: \(channelLink)")
            }
        }
        return fetchedFeedDatas
    }
    
    // MARK: - XMLParserDelegateMethods
    //開始タグが見つかった時に呼ばれるメソッド
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        self.currentString = "" // 現在処理中のXML要素を保存するcurrentStringを初期化しておく
        if elementName == "channel" { // Channelという要素の中にtitle(FeedData.category)があるか、itemという要素の中にtitle(FeedData.title)があるかを識別する
            self.isInsideChannel = true
        }
        if elementName == "item" { // itemという要素が見つかるたびに
            self.isInsideChannel = false
            self.feedData = FeedData() // FeedDataインスタンスが初期化される
        }
    }
    
    //テキストデータが見つかった時に呼ばれるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentString += string // 配下の要素が見つかるたびにString型でcurrentStringに代入され続ける。TODO: なぜインクリメント？要確認
    }
    
    //終了タグが見つかった時に呼ばれるメソッド
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if self.isInsideChannel {
            switch elementName { // 解析時　一番最初にchannnel要素ないが呼び出されるはず　その際　事前にカテゴリ名をプロパティとして保存する　こうすることでfeedDataの初期化を免れることができる
            case "title": self.parsingCategory = currentString
            default: break
            }
        }
        switch elementName { // XML要素
        case "title": self.feedData?.title = currentString
            self.feedData?.category = self.parsingCategory
        case "link": self.feedData?.link = currentString
        case "pubDate": self.feedData?.pubDate = currentString //FIXME: XML(英語)そのままでなく日本語表記にコンバートしたい
        case "item": self.feedDatas.append(self.feedData!)
        default: break
        }
    }
    // パースが完了した時に呼ばれるメソッド
    func parserDidEndDocument(_ parser: XMLParser) {
        // パースが完了したときにデータを使用するか、出力するなどの処理をここに追加できます。
        self.currentString = "" // FIXME: パースされた値の格納に使用したcurrentStringを初期化しているが、別にいらないorもっと適切な書き方ある？
    }
}
