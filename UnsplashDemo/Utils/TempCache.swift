//
//  TempCache.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import Foundation

struct TempCache<Key: Hashable, Value> {

    // MARK: - Properties
    private var dictionaryWithHistory: [Key: (Value, Date)] = [:]

    private let threshold: Int
    private let evictionCount: Int

    // MARK: - Initialize
    init(threshold: Int) {
        assert(threshold > 0, "The threshold of cache eviction must be greater than 0")
        self.threshold = threshold
        let clamped = min(Double(threshold), max(Double(threshold) * 0.1, 5.0))
        self.evictionCount = Int(floor(clamped))
    }

    subscript(key: Key) -> Value? {
        mutating get {
            // cache hit
            if let ret = dictionaryWithHistory[key] {
                dictionaryWithHistory[key] = (ret.0, Date())
                return ret.0
            }
            // cache miss
            return nil
        }
        set {
            // remove item
            guard let value = newValue else {
                dictionaryWithHistory[key] = nil
                return
            }
            // existing one: update date
            dictionaryWithHistory[key] = (value, Date())
            // cache eviction
            if dictionaryWithHistory.count > threshold {
                let oldKeys = dictionaryWithHistory
                    .sorted { $0.value.1 < $1.value.1 }
                    .prefix(through: evictionCount).map { $0.key }
                oldKeys.forEach {
                    dictionaryWithHistory[$0] = nil
                }
            }
        }
    }

}
