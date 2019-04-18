//
//  TicketContract.swift
//  platonWeb3Demo
//
//  Created by Ned on 22/1/2019.
//  Copyright © 2019 ju. All rights reserved.
//

import Foundation

open class TicketContract: Contract{
    
    private var web3 : Web3
    
    required public init(web3: Web3) {
        self.web3 = web3
    }
    
    public let contractAddress = "0x1000000000000000000000000000000000000002"
    
    public func GetTicketPrice(completion: PlatonCommonCompletion?){
        
        var completion = completion
        let data = self.build_GetTicketPrice()
        
        web3.eth.platonCall(contractAddress: contractAddress, data: data, from: nil, gas: nil, gasPrice: nil, value: nil, outputs: [SolidityFunctionParameter(name: "", type: .string)]) { (res, data) in
            
            switch res{
            case .success:
                guard let dic = data as? [String:String], let resp = dic[""] else {
                    self.failCompletionOnMainThread(code: -2, errorMsg: "data parse Error", completion: &completion)
                    return
                }
                self.successCompletionOnMain(obj: resp as AnyObject, completion: &completion)
            case .fail(let code, let msg):
                self.failCompletionOnMainThread(code: code ?? -1, errorMsg: msg ?? "failed", completion: &completion)
            }
        }
    }
    
    
    public func GetPoolRemainder(completion: PlatonCommonCompletion?){
        
        var completion = completion
        let data = build_GetPoolRemainder()
        
        web3.eth.platonCall(contractAddress: contractAddress, data: data, from: nil, gas: nil, gasPrice: nil, value: nil, outputs: [SolidityFunctionParameter(name: "", type: .string)]) { (res, data) in
            
            switch res{
            case .success:
                guard let dic = data as? [String:String], let resp = dic[""] else {
                    self.failCompletionOnMainThread(code: -2, errorMsg: "data parse Error", completion: &completion)
                    return
                }
                self.successCompletionOnMain(obj: resp as AnyObject, completion: &completion)
            case .fail(let code, let msg):
                self.failCompletionOnMainThread(code: code ?? -1, errorMsg: msg ?? "failed", completion: &completion)
            }
        }
    }
    
    public func GetCandidateEpoch(candidateId: String, completion: PlatonCommonCompletion?) {
        
        var completion = completion
        
        let data = self.build_GetCandidateEpoch(candidateId: candidateId)
        
        web3.eth.platonCall(contractAddress: contractAddress, data: data, from: nil, gas: nil, gasPrice: nil, value: nil, outputs: [SolidityFunctionParameter(name: "", type: .string)]) { (res, data) in
            
            switch res{
            case .success:
                guard let dic = data as? [String:String], let resp = dic[""] else {
                    self.failCompletionOnMainThread(code: -2, errorMsg: "data parse Error", completion: &completion)
                    return
                }
                self.successCompletionOnMain(obj: resp as AnyObject, completion: &completion)
            case .fail(let code, let msg):
                self.failCompletionOnMainThread(code: code ?? -1, errorMsg: msg ?? "failed", completion: &completion)
            }
        }
        
    }
    
    public func GetTicketDetail(ticketId: String, completion: PlatonCommonCompletion?) {
        
        var completion = completion
        
        let data = self.build_GetTicketDetail(ticketId: ticketId)
        
        web3.eth.platonCall(contractAddress: contractAddress, data: data, from: nil, gas: nil, gasPrice: nil, value: nil, outputs: [SolidityFunctionParameter(name: "", type: .string)]) { (res, data) in
            
            switch res{
            case .success:
                guard let dic = data as? [String:String], let resp = dic[""] else {
                    self.failCompletionOnMainThread(code: -2, errorMsg: "data parse Error", completion: &completion)
                    return
                }
                self.successCompletionOnMain(obj: resp as AnyObject, completion: &completion)
            case .fail(let code, let msg):
                self.failCompletionOnMainThread(code: code ?? -1, errorMsg: msg ?? "failed", completion: &completion)
            }
        }
        
        
    }
    
    public func GetTicketCountByTxHash(ticketIds: [String], completion: PlatonCommonCompletion?){
        var completion = completion
        let data = self.build_GetTicketCountByTxHash(ticketIds: ticketIds)
        web3.eth.platonCall(contractAddress: contractAddress, data: data, from: nil, gas: nil, gasPrice: nil, value: nil, outputs: [SolidityFunctionParameter(name: "", type: .string)]) { (res, data) in
            
            switch res{
            case .success:
                guard let dic = data as? [String:String], let resp = dic[""] else {
                    self.failCompletionOnMainThread(code: -2, errorMsg: "data parse Error", completion: &completion)
                    return
                }
                self.successCompletionOnMain(obj: resp as AnyObject, completion: &completion)
            case .fail(let code, let msg):
                self.failCompletionOnMainThread(code: code ?? -1, errorMsg: msg ?? "failed", completion: &completion)
            }
        }
        
    }
    
    public func GetCandidateTicketCount(nodeIds: [String], completion: PlatonCommonCompletion?){
        var completion = completion
        let data = self.build_GetCandidateTicketCount(nodeIds: nodeIds)
        
        web3.eth.platonCall(contractAddress: contractAddress, data: data, from: nil, gas: nil, gasPrice: nil, value: nil, outputs: [SolidityFunctionParameter(name: "", type: .string)]) { (res, data) in
            
            switch res{
            case .success:
                guard let dic = data as? [String:String], let resp = dic[""] else {
                    self.failCompletionOnMainThread(code: -2, errorMsg: "data parse Error", completion: &completion)
                    return
                }
                self.successCompletionOnMain(obj: resp as AnyObject, completion: &completion)
            case .fail(let code, let msg):
                self.failCompletionOnMainThread(code: code ?? -1, errorMsg: msg ?? "failed", completion: &completion)
            }
        }
    }
    
    public func VoteTicket(count: UInt32, price: BigUInt, nodeId: String, sender: String, privateKey: String, gasPrice: BigUInt, gas: BigUInt, completion: PlatonCommonCompletion?){
        var completion = completion
        let data = self.build_VoteTicket(count: count, price: price, nodeId: nodeId)
        
        let value = EthereumQuantity(quantity: price.multiplied(by: BigUInt(count)))
        web3.eth.platonSendRawTransaction(contractAddress: contractAddress, data: data.bytes, sender: sender, privateKey: privateKey, gasPrice: gasPrice, gas: gas,value: value, estimated: false) { (result, data) in
            switch result{
                
            case .success:
                
                guard let txHashData = data else {
                    self.failCompletionOnMainThread(code: -1, errorMsg: "data parse error!", completion: &completion)
                    return
                }
      
                self.successCompletionOnMain(obj: txHashData as AnyObject, completion: &completion)
   
            case .fail(let code, let errMsg):
                self.failCompletionOnMainThread(code: code!, errorMsg: errMsg!, completion: &completion)
            }
        }
        
    }
    
    
}

extension TicketContract{
    
    private func build_commonInternalCall(funcName: String, param: String? = nil) -> Data {
        
        let txTypePart = RLPItem(bytes: ExecuteCode.InnerContract.DataValue.bytes)
        
        let funcItemPart = RLPItem(bytes: (funcName.data(using: .utf8)?.bytes)!)
        
        var items : [RLPItem] = []
        
        items.append(txTypePart)
        items.append(funcItemPart)
        
        if param != nil {
            let paramData = param!.data(using: .utf8)
            items.append(RLPItem(bytes: paramData!.bytes))
        }
        
        let rlp = RLPItem.array(items)
        
        let rawRlp = try? RLPEncoder().encode(rlp)
        
        return Data(bytes: rawRlp!)
    }
    
    func build_GetTicketPrice() -> Data{
        
        return build_commonInternalCall(funcName: "GetTicketPrice")
    }
    
    func build_GetPoolRemainder() -> Data {
        
        return build_commonInternalCall(funcName: "GetPoolRemainder")
    }
    
    func build_GetCandidateEpoch(candidateId: String) -> Data{
        
        return build_commonInternalCall(funcName: "GetCandidateEpoch", param: candidateId)
    }
    
    func build_CandidateDetails(candidateId: String) -> Data {
        
        return build_commonInternalCall(funcName: "CandidateDetails", param: candidateId)
    }
    
    func build_CandidateList() -> Data{
        
        return build_commonInternalCall(funcName: "CandidateList")
    }
    
    func build_GetTicketDetail(ticketId: String) -> Data{
        
        return build_commonInternalCall(funcName: "GetTicketDetail", param: ticketId)
    }
    
    func build_GetTicketCountByTxHash(ticketIds: [String]) -> Data{
        
        let concatenate = ticketIds.joined(separator: ":")
        return build_commonInternalCall(funcName: "GetTicketCountByTxHash", param: concatenate)
        
    }
    
    func build_GetBatchCandidateDetail(nodeIds: [String]) -> Data {
        
        let concatenate = nodeIds.joined(separator: ":")
        return build_commonInternalCall(funcName: "GetBatchCandidateDetail", param: concatenate)
        
    }
    
    func build_GetCandidateTicketCount(nodeIds:[String]) -> Data {
        
        let concatenate = nodeIds.joined(separator: ":")
        return build_commonInternalCall(funcName: "GetCandidateTicketCount", param: concatenate)
        
    }
    
    func build_VoteTicket(count: UInt32, price: BigUInt,nodeId: String) -> Data{
        
        let count_d = Data.newData(uint32data: UInt32(count), bigEndian: false)
        
        
        let priceV = SolidityWrappedValue(value: price, type: SolidityType.uint256)
        let price_d = Data(hex: priceV.value.abiEncode(dynamic: false)!)
        
        //let price_d = Data(price.makeBytes())
        
        
        //let nodeId_d = Data(hex: nodeId)
        
        let nodeId_d = nodeId.data(using: .utf8)
        
        let params = [count_d,price_d,nodeId_d]
        
        let txTypePart = RLPItem(bytes: ExecuteCode.Vote.DataValue.bytes)
        let funcItemPart = RLPItem(bytes: ("VoteTicket".data(using: .utf8)?.bytes)!)
        var items : [RLPItem] = []
        items.append(txTypePart)
        items.append(funcItemPart)
        
        for sdata in params{
            items.append(RLPItem(bytes: sdata!.bytes))
        }
        
        let rlp = RLPItem.array(items)
        let rawRlp = try? RLPEncoder().encode(rlp)
        
        return Data(bytes: rawRlp!)
    }
    
    public static func generateTickets(txHash: Data, count: UInt32) -> [String]{
        var tickets = [String]()
        for i in 0..<count {
            let ticketId = generateTicketId(txHash: txHash, index: i)
            tickets.append(ticketId)
        }
        return tickets
    }
    
    public static func generateTicketId(txHash: Data, index: UInt32) -> String {
        var data = txHash
        for c in String(index).unicodeScalars {
            data.append(UInt8(c.value))
        }
        return "0x\(data.sha3(.sha256).toHexString())"
    }
}
