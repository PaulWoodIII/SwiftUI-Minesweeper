//
//  Pulse.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/31/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import Combine

class Pulse: ObservableObject {
  var shouldEmmit: CurrentValueSubject<Bool, Never>
  public var publisher: AnyPublisher<Void, Never>
  init(interval: TimeInterval) {
    let shouldEmmit = CurrentValueSubject<Bool, Never>(false)
    let publisher = Timer.publish(every: interval, on: RunLoop.main, in: .default)
      .autoconnect()
      .filter({ _ in shouldEmmit.value })
      .map { _ -> Void in  }
      .eraseToAnyPublisher()
    self.shouldEmmit = shouldEmmit
    self.publisher = publisher
  }
  public func toggle() {
    self.shouldEmmit.send(!self.shouldEmmit.value)
  }
}
