//
//  TriggerSet.swift
//  StealthyStashDemo
//
//  Created by Leo Dion on 6/15/23.
//

import Combine

class TriggerSet {
  let saveCompletedTrigger = PassthroughSubject<Void, Never>()

  var receiveUpdatePublisher: AnyPublisher<Void, Never> {
    saveCompletedTrigger.share().eraseToAnyPublisher()
  }
}
