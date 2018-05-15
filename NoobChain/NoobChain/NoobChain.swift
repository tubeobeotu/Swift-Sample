//
//  NoobChain.swift
//  NoobChain
//
//  Created by tea on 5/15/18.
//  Copyright © 2018 tea. All rights reserved.
//

import Foundation

class NoobChain{
    init() {
        let block1 = Block.init(data: "First block", previousHash: "0")
        block1.mineBlock(difficulty: 4)
        let block2 = Block.init(data: "Second block", previousHash: block1.hash)
//        block2.mineBlock(difficulty: 4)
        let block3 = Block.init(data: "Third block", previousHash: block2.hash)
//        block3.mineBlock(difficulty: 4)
        print("Hash for block 1: \(block1.hash!)")
        print("Hash for block 2: \(block2.hash!)")
        print("Hash for block 3: \(block3.hash!)")
        
        print(block1)
        print(block2)
        print(block3)
    }
    
    func isChainValid(blocks: [Block]) -> Bool
    {
        var block1: Block!
        var block2: Block!
        
        for index in 1..<blocks.count{
            block1 = blocks[index]
            block2 = blocks[index - 1]
            
            if(block1.hash != block2.hash){
                print("Current hashes not equal")
                return false
            }
            
            if(block1.previousHash != block2.previousHash){
                print("Previous hashes not equal")
                return false
            }
        }
        
        return true
    }
    
    
}
class Block
{
    var hash:String!
    var previousHash:String!
    var data:String!
    var timeStamp:Double!
    
    var nonce:Int = 0
    
    init(data: String, previousHash: String) {
        self.data = data
        self.previousHash = previousHash
        self.timeStamp = Date().timeIntervalSince1970
        
        self.hash = self.calculateHash()
    }
    
    func calculateHash() -> String{
        return (previousHash! + "\(timeStamp)" + "\(nonce)"  + data!).sha256()
    }
    
    func mineBlock(difficulty: Int){
        let target = difficulty.generateDifficulty()
        while (self.hash.substring(difficulty) != target) {
            nonce = nonce + 1
            self.hash = calculateHash()
        }
        
    }
    
}
extension Int{
    func generateDifficulty() -> String{
        var result = ""
        var index = self
        while index > 0 {
            index = index - 1
            result = result + "0"
        }
        return result
    }
        
}
extension String {
    
    func substring(_ to: Int) -> String {
        let start = index(startIndex, offsetBy: to)
        return String(self[..<start])
    }
}
extension String {
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
    
}
