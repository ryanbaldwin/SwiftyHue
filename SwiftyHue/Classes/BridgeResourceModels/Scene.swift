//
//  Scene.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation
import Gloss

//public class Scene: PartialScene {
//    
//    public let lightstates: [LightState]?;
//    
//    public required init?(json: JSON) {
//        
//        var lightStates = json["lightstates"]
//        
//        if lightStates != nil {
//            
//            var lightstateJSONS = TestRequester.convert((lightStates as! NSDictionary).mutableCopy() as! NSMutableDictionary)
//            self.lightstates = Array.fromJSONArray(lightstateJSONS);
//        
//        } else {
//            self.lightstates = nil;
//        }
//        
//        super.init(json: json)
//    }
//    
//}

public class PartialScene: BridgeResource, BridgeResourceDictGenerator {
    
    public typealias AssociatedBridgeResourceType = PartialScene
    
    public let identifier: String
    public let name: String
    public let lightIdentifiers: [String]
    public let owner: String
    public let recycle: Bool
    public let locked: Bool
    public let appData: AppData?
    public let picture: String?
    public let lastUpdated: NSDate?
    public let version: Int
    
    public required init?(json: JSON) {
        
        guard let identifier: String = "id" <~~ json,
            let name: String = "name" <~~ json,
            let lightIdentifiers: [String] = "lights" <~~ json,
            let owner: String = "owner" <~~ json,
            let recycle: Bool = "recycle" <~~ json,
            let locked: Bool = "locked" <~~ json,
            let version: Int = "version" <~~ json
        
            else { return nil }
        
        self.identifier = identifier
        self.name = name
        self.lightIdentifiers = lightIdentifiers
        self.owner = owner
        self.recycle = recycle
        self.locked = locked
        self.version = version
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        self.appData = "appdata" <~~ json
        picture = "picture" <~~ json
        lastUpdated = Decoder.decodeDate("lastupdated", dateFormatter:dateFormatter)(json)
    }
    
    public func toJSON() -> JSON? {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        var json = jsonify([
            "identifier" ~~> self.identifier,
            "name" ~~> self.name,
            "lights" ~~> self.lightIdentifiers,
            "owner" ~~> self.owner,
            "recycle" ~~> self.recycle,
            "locked" ~~> self.locked,
            "appdata" ~~> self.appData,
            "picture" ~~> self.picture,
            "lastupdated" ~~> Encoder.encodeDate("lastupdated", dateFormatter: dateFormatter)(self.lastUpdated),
            "version" ~~> self.version
            ])
        
        return json
    }
    
}

extension PartialScene: Hashable {
    
    public var hashValue: Int {
        
        return Int(identifier)!
    }
}

public func ==(lhs: PartialScene, rhs: PartialScene) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        (lhs.lightIdentifiers ?? []) == (rhs.lightIdentifiers ?? []) &&
        lhs.owner == rhs.owner &&
        lhs.recycle == rhs.recycle &&
        lhs.locked == rhs.locked &&
        lhs.appData == rhs.appData &&
        lhs.picture == rhs.picture &&
        lhs.lastUpdated == rhs.lastUpdated &&
        lhs.version == rhs.version
}