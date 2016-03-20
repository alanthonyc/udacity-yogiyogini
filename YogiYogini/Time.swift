//
//  Time.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/19/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//
//  All credit for the idea of this module goes to Soroush Khanlou,
//  via his blog post @: http://khanlou.com/2016/03/units/
//

import Foundation

protocol Time
{
    var asDouble: Double { get }
    var inSeconds: Double { get }
    var inMinutes: Double { get }
    var inHours: Double { get }
    var string: String { get }
    var paddedString: String { get }
    
    func multipliedBy(multiplier: Double) -> Time
}

struct Hours: Time
{
    let value: Double
    
    init(value: Double)
    {
        self.value = value * 3600
    }
    
    var asDouble: Double
    {
        return floor(value / 3600)
    }
    
    var inSeconds: Double
    {
        return value
    }
    
    var inMinutes: Double
    {
        return floor(value / 60)
    }
    
    var inHours: Double
    {
        return floor(value / 3600)
    }
    
    var string: String
    {
        return "\(Int(inHours))"
    }
    
    var paddedString: String
    {
        if asDouble < 10 { return String(format:"0%.0f", asDouble) }
        return String(format: "%.0f", asDouble)
    }
    
    func multipliedBy(multiplier: Double) -> Time
    {
        return Hours(value: asDouble * multiplier)
    }
}

struct Minutes: Time
{
    let value: Double
    
    init(value: Double)
    {
        self.value = value * 60
    }
    
    var asDouble: Double
    {
        return floor(value / 60)
    }
    
    var inSeconds: Double
    {
        return value
    }
    
    var inMinutes: Double
    {
        return floor(value / 60)
    }
    
    var inHours: Double
    {
        return floor(value / 3600)
    }
    
    var string: String
    {
        return "\(Int(inMinutes))"
    }
    
    var paddedString: String
    {
        if asDouble < 10 { return String(format:"0%.0f", asDouble) }
        return String(format: "%.0f", asDouble)
    }
    
    func multipliedBy(multiplier: Double) -> Time
    {
        return Minutes(value: asDouble * multiplier)
    }
}

struct Seconds: Time
{
    let value: Double
    
    var asDouble: Double
    {
        return value
    }
    
    var inSeconds: Double
    {
        return value
    }
    
    var inMinutes: Double
    {
        return floor(value / 60)
    }
    
    var inHours: Double
    {
        return floor(value / 3600)
    }
    
    var string: String
    {
        return "\(Int(value))"
    }
    
    var paddedString: String
    {
        if asDouble < 10 { return String(format:"0%.0f", asDouble) }
        return String(format: "%.0f", asDouble)
    }
    
    func multipliedBy(multiplier: Double) -> Time
    {
        return Seconds(value: value * multiplier)
    }
}

func + (lhs: Time, rhs: Time) -> Time
{
    return Seconds(value: lhs.inSeconds + rhs.inSeconds)
}

func - (lhs: Time, rhs: Time) -> Time
{
    return Seconds(value: lhs.inSeconds - rhs.inSeconds)
}

extension Time
{
    func components() -> (Time, Time, Time)
    {
        let hours = floor(inSeconds / 3600)
        let remaining = inSeconds % 3600
        let minutes = floor(remaining / 60)
        let seconds = floor(remaining % 60)
        return (Hours(value: hours), Minutes(value: minutes), Seconds(value: seconds))
    }
}

extension Int
{
    var hours: Time
    {
        return Hours(value: Double(self))
    }
    
    var minutes: Time
    {
        return Minutes(value: Double(self))
    }
}