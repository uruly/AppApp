//
//  String+Path.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/23.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

extension String {
    
    private var ns: String {
        return (self as String)
    }
    
    public func substring(from index: Int) -> String {
        return ns.substring(from: index)
    }
    
    public func substring(to index: Int) -> String {
        return ns.substring(to: index)
    }
    
    public func substring(with range: Range<Character>) -> String {
        return ns.substring(with: range)
    }
    
    public var lastPathComponent: String {
        return ns.lastPathComponent
    }
    
    public var pathExtension: String {
        return ns.pathExtension
    }
    
    public var deletingLastPathComponent: String {
        return ns.deletingLastPathComponent
    }
    
    public var deletingPathExtension: String {
        return ns.deletingPathExtension
    }
    
    public var pathComponents: [String] {
        return ns.pathComponents
    }
    
    public func appendingPathComponent(_ str: String) -> String {
        return ns.appendingPathComponent(str)
    }
    
    public func appendingPathExtension(_ str: String) -> String? {
        return ns.appendingPathExtension(str)
    }
}
