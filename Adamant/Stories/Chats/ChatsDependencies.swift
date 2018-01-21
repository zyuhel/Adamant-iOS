//
//  ChatsDependencies.swift
//  Adamant-ios
//
//  Created by Anokhov Pavel on 12.01.2018.
//  Copyright © 2018 Adamant. All rights reserved.
//

import Swinject

extension Container {
	func registerAdamantChatsStory() {
		self.storyboardInitCompleted(ChatsListViewController.self) { r, c in
			c.accountService = r.resolve(AccountService.self)
			c.chatProvider = r.resolve(ChatDataProvider.self)
			c.cellFactory = r.resolve(CellFactory.self)
			c.apiService = r.resolve(ApiService.self)
			c.router = r.resolve(Router.self)
		}
		
		self.storyboardInitCompleted(ChatViewController.self) { r, c in
			c.chatProvider = r.resolve(ChatDataProvider.self)
			c.feeCalculator = r.resolve(FeeCalculator.self)
		}
	}
}
