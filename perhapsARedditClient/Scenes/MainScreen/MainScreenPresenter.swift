//
//  MainScreenPresenter.swift
//  perhapsARedditClient
//
//  Created by a on 03.09.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainScreenPresentationLogic {
    func presentPosts(response: MainScreen.GetPosts.Response)
    func presentAddedPosts(response: MainScreen.GetPosts.Response)
    func refreshHiddenPosts(response: MainScreen.refreshHiddenPost.Response)
}

class MainScreenPresenter: MainScreenPresentationLogic {
    // MARK: - Clean Components
    
    weak var viewController: MainScreenDisplayLogic?
    private var iconUrlStrings: [String] = []
    
    // MARK: - Methods
    
    private func configureTableModel(from data: [Post]) -> [PostForTable] {
        var tableModel = [PostForTable]()
        var i = 0
        
        tableModel.append(contentsOf: data.map {
            var isGif = false
            var videoUrlString: String? = nil
            i += 1
            
            if let url = $0.url_overridden_by_dest {
                if "\(url)".contains(".gif") { isGif = true }
            }
            
            if let videoType = $0.media?.reddit_video {
                videoUrlString = videoType.fallback_url
            }
            print($0.selftext)
            return PostForTable(
                postTitle: $0.title,
                id: $0.id,
                voteCount: voteCount(score: $0.score),
                picture: $0.url_overridden_by_dest,
                subredditIcon: $0.thumbnail,
                thumbnail: $0.thumbnail,
                subreddit: "r/\($0.subreddit)",
                domain: $0.domain,
                oPUsername: "u/\($0.author)",
                timePassed: timePassed(created_utc: $0.created_utc),
                iconUrlString: iconUrlStrings[i-1],
                isVideo: $0.is_video,
                isGif: isGif,
                VideoUrlString: removeExtraUrlString(url: videoUrlString, extensionString: ".mp4"),
                bodyText: $0.selftext
            )  
        })
        return tableModel
    }
    
    func redditPostsToPosts(rawData: RedditPosts) -> [Post] {
        var posts: [Post] = []
        rawData.data.children.forEach { posts += [$0.data] }
        return posts
    }
    
    func timePassed(created_utc: Double) -> String {
        let epocTime = Int(TimeInterval(created_utc))
        let currentTime = Int(Date().timeIntervalSince1970)
        var differance = currentTime - epocTime
        var returnString = ""
        
        if differance / 60 < 60 && differance > 0  {
            returnString = "\(differance / 60)min"
        } else {
            differance = differance / 3600
            if differance < 24 && differance > 0 {
                returnString = "\(differance)h"
            } else {
                differance = differance / 24
                if differance < 30 && differance > 0  {
                    returnString = "\(differance)d"
                } else {
                    differance = differance / 30
                    if differance < 12 && differance > 0  {
                        returnString = "\(differance)m"
                    } else {
                        differance = differance / 12
                        returnString = "\(differance)y"
                    }
                }
            }
        }
        return returnString
    }
    
    func voteCount(score: Int) -> String {
        var returnString = ""
        if score > 999 {
            returnString = "\(round(Double(score)/100)/10)K"
        } else { returnString = "\(score)" }
        return returnString
    }
    
    func removeExtraUrlString(url: String?, extensionString: String) -> String? {
        guard var string = url else { return url }
        if let dotRange = string.range(of: extensionString) {
            string.removeSubrange(dotRange.lowerBound..<string.endIndex)
            string += extensionString
        }
        return string
    }
    
}

// MARK: - PresentationLogic

extension MainScreenPresenter {
    
    func presentPosts(response: MainScreen.GetPosts.Response) {
        
        iconUrlStrings = response.iconUrlStrings
        
        let data = redditPostsToPosts(rawData: response.data)
        let viewModel = configureTableModel(from: data)
        
        viewController?.displayPosts(viewModel: MainScreen.GetPosts.ViewModel(tableData: viewModel, hiddenPosts: response.hiddenPosts))
        viewController?.revealTable()
    }
    
    func presentAddedPosts(response: MainScreen.GetPosts.Response) {
        
        iconUrlStrings = response.iconUrlStrings
        
        let data = redditPostsToPosts(rawData: response.data)
        let viewModel = configureTableModel(from: data)
        
        viewController?.displayAddedPosts(viewModel: MainScreen.GetPosts.ViewModel(tableData: viewModel, hiddenPosts: response.hiddenPosts))
        viewController?.displayAddedPosts(viewModel: MainScreen.GetPosts.ViewModel(tableData: viewModel, hiddenPosts: response.hiddenPosts))
    }
    
    func refreshHiddenPosts(response: MainScreen.refreshHiddenPost.Response) {
        viewController?.refreshHiddenPosts(viewModel: MainScreen.refreshHiddenPost.ViewModel(posts: response.posts))
    }
}

