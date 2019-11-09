//
//  platonWeb3DemoTests.swift
//  platonWeb3DemoTests
//
//  Created by Admin on 16/4/2019.
//  Copyright © 2019 ju. All rights reserved.
//

import XCTest
@testable import platonWeb3Demo

class platonWeb3DemoTests: XCTestCase {

    let sender = "0x45886FFccf2C6726F44Deec15446F9A53c007848"
    let privateKey = "6fe419582271a4dcf01c51b89195b77b228377fde4bde6e04ef126a0b4373f79"
    var gasPrice: BigUInt!
    var gas: BigUInt!
    var deployedContractAddress: String!
    let nodeId = "0x11f00fd6ea74431c04d336428a5e95736673ee17547c1ccb58d3a64d7224bc7affac84a44b64500f7f35d3875be37078cfc95537a433c764e1921623718c8fdf";
    var senderAddress: EthereumAddress!

    let web3: Web3 = Web3(rpcURL: "http://192.168.9.190:443/rpc", chainId: "103")
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitWeb3() {
        XCTAssert(web3.chainId == "103", "web3.chainid should be 101")
        XCTAssertNotNil(web3.platon, "web3.platon should be not nil")
        XCTAssertNotNil(web3.properties, "web3.properties should be not nil")
        XCTAssertNotNil(web3.proposal, "web3.proposal should be not nil")
        XCTAssertNotNil(web3.restricting, "web3.restricting should be not nil")
        XCTAssertNotNil(web3.slash, "web3.slash should be not nil")
        XCTAssertNotNil(web3.staking, "web3.staking should be not nil")
    }

    func testForCreateStaking() {
        let expection = self.expectation(description: "\(#function)")

        let typ = UInt16(0)
        let bAddress = "0xCD91820AbDE9Df12Ed384eC0da05b76e42C6Afa3"
        let nodeId = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"
        let externalId = "liyf-test-id"
        let nodeName = "yujinghan-node"
        let website = "www.baidu.com"
        let details = "f**king stupid"
        let amount = BigUInt("5000000").multiplied(by: PlatonConfig.VON.LAT)
        let blsPubKey = "80d98a48400a36e3da9de8e227e4a8c8fa3f90c08c82a467c9ac01298c2eb57f543d7e9568b0f381cc6c9de911870d1292b62459d083700d3958d775fca60e41ddd7d8532163f5acabaa6e0c47b626c39de51d9d67fb97a5af1871a661ca7788"

        let semaphore = DispatchSemaphore(value: 1)

        semaphore.wait()
        var programVersion: ProgramVersion?
        let pvWeb3 = Web3(rpcURL: "http://192.168.120.145:6790/rpc", chainId: "103")
        pvWeb3.platon.getProgramVersion { (response) in
            programVersion = response.result
            semaphore.signal()
        }

        semaphore.wait()
        var blsProof: String?
        pvWeb3.platon.getSchnorrNIZKProve { (response) in
            blsProof = response.result
            semaphore.signal()
        }

        semaphore.wait()
        guard
            let pVersion = programVersion,
            let PV = pVersion.Version,
            let PVS = pVersion.Sign,
            let blsProofString = blsProof
        else {
            semaphore.signal()
            XCTAssert(false, "get failed programversion & blsProof")
            return
        }

        web3.staking.createStaking(
            typ: typ,
            benifitAddress: bAddress,
            nodeId: nodeId,
            externalId: externalId,
            nodeName: nodeName,
            website: website,
            details: details,
            amount: amount,
            sender: sender,
            privateKey: privateKey,
            programVersion: PV,
            programVersionSign: PVS,
            blsPubKey: blsPubKey,
            blsProof: blsProofString) { (result, response) in
                switch result {
                case .success:
                    guard let data = response else {
                        XCTAssert(false, "response should be not nil")
                        return
                    }
                    let txHash = data.toHexString()
                    print(txHash)
                    XCTAssert(txHash.count > 0, "tx hash should be bot nil")
                case .fail(_, let error):
                    XCTAssert(false, error ?? "send tx fail")
                    break
                }
                semaphore.signal()
                expection.fulfill()
        }

        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForEditorStaking() {
        let expection = XCTestExpectation(description: "\(#function)")

        let bAddress = "0xCD91820AbDE9Df12Ed384eC0da05b76e42C6Afa3"
        let nodeId = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"
        let externalId = "111111"
        let nodeName = "platon"
        let website = "https://www.test.network"
        let details = "supper node"

        web3.staking.editorStaking(
            benifitAddress: bAddress,
            nodeId: nodeId,
            externalId: externalId,
            nodeName: nodeName,
            website: website,
            details: details,
            sender: sender,
            privateKey: privateKey) { (result, response) in
                switch result {
                case .success:
                    guard let data = response else {
                        XCTAssert(false, "response should be not nil")
                        return
                    }
                    let txHash = data.toHexString()
                    print(txHash)
                    XCTAssert(txHash.count > 0, "tx hash should be bot nil")
                case .fail(_, let error):
                    XCTAssert(false, error ?? "send tx fail")
                    break
                }
                expection.fulfill()
        }

        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForIncreseStaking() {
        let expection = self.expectation(description: "\(#function)")

        let typ = UInt16(0)
        let nodeId = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"
        let amount = BigUInt("1000000").multiplied(by: PlatonConfig.VON.LAT)

        web3.staking.increseStaking(
            nodeId: nodeId,
            typ: typ,
            amount: amount,
            sender: sender,
            privateKey: privateKey) { (result, response) in
                switch result {
                case .success:
                    guard let data = response else {
                        XCTAssert(false, "response should be not nil")
                        return
                    }
                    let txHash = data.toHexString()
                    print(txHash)
                    XCTAssert(txHash.count > 0, "tx hash should be bot nil")
                case .fail(_, let error):
                    XCTAssert(false, error ?? "send tx fail")
                }
                expection.fulfill()
        }

        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForWithdrewStaking() {
        let expection = self.expectation(description: "\(#function)")

        let nodeId = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"
        web3.staking.withdrewStaking(nodeId: nodeId, sender: sender, privateKey: privateKey) { (result, response) in
            switch result {
            case .success:
                guard let data = response else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
                let txHash = data.toHexString()
                print(txHash)
                XCTAssert(txHash.count > 0, "tx hash should be bot nil")
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }

        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForDelegate() {
        let expection = self.expectation(description: "\(#function)")
        let typ: UInt16 = 0
        let nodeId = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"
        let amount = BigUInt(10).multiplied(by: PlatonConfig.VON.LAT)
        let delSender = "0x9485d892649d64060cA7fD4F6753410D50938731"
        let delPrivateKey = "6550e1766143542227033b47ff908a5981ad8a36e4508180bd52418b2e8aed5c"

        web3.staking.createDelegate(
            typ: typ,
            nodeId: nodeId,
            amount: amount,
            sender: delSender,
            privateKey: delPrivateKey) { (result, response) in
                switch result {
                case .success:
                    guard let data = response else {
                        XCTAssert(false, "response should be not nil")
                        return
                    }
                    let txHash = data.toHexString()
                    print(txHash)
                    XCTAssert(txHash.count > 0, "tx hash should be bot nil")
                case .fail(_, let error):
                    XCTAssert(false, error ?? "send tx fail")
                }
                expection.fulfill()
        }

        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForWithDrawDelegate() {
        let expection = self.expectation(description: "\(#function)")

        let stakingBlockNum = UInt64(1000)
        let nodeId = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"
        let amount = BigUInt("1000000000000000000000000")

        web3.staking.withdrewDelegate(
            stakingBlockNum: stakingBlockNum,
            nodeId: nodeId,
            amount: amount,
            sender: sender,
            privateKey: privateKey) { (result, response) in
                switch result {
                case .success:
                    guard let data = response else {
                        XCTAssert(false, "response should be not nil")
                        return
                    }
                    let txHash = data.toHexString()
                    print(txHash)
                    XCTAssert(txHash.count > 0, "tx hash should be bot nil")
                case .fail(_, let error):
                    XCTAssert(false, error ?? "send tx fail")
                }
                expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForGetVerifierList() {
        let expection = self.expectation(description: "\(#function)")

        web3.staking.getVerifierList(sender: sender) { (result, response) in
            switch result {
            case .success:
                guard let data = response?.result else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
                XCTAssert(data.count > 0, "verifier count should be > 0")
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForGetValidatorList() {
        let expection = self.expectation(description: "\(#function)")
        web3.staking.getValidatorList(sender: sender) { (result, response) in
            switch result {
            case .success:
                guard let data = response?.result else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
                XCTAssert(data.count > 0, "validator count should be > 0")
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForGetCandidateList() {
        let expection = self.expectation(description: "\(#function)")
        web3.staking.getCandidateList(sender: sender) { (result, response) in
            switch result {
            case .success:
                guard let data = response?.result else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
                XCTAssert(data.count > 0, "candidate count should be > 0")
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForGetRelatedListByDelAddr() {
        let expection = self.expectation(description: "\(#function)")
        web3.staking.getDelegateListByDelAddr(sender: sender, addr: sender) { (result, response) in
            switch result {
            case .success:
                guard let _ = response?.result else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForGetDelegateInfo() {
        let expection = self.expectation(description: "\(#function)")
        let stakingBlockNum = UInt64(636)
        let nodeId = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"
        web3.staking.getDelegateInfo(sender: sender, stakingBlockNum: stakingBlockNum, delAddr: sender, nodeId: nodeId) { (result, response) in
            switch result {
            case .success:
                guard let _ = response?.result else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForGetCandidateInfo() {
        let expection = self.expectation(description: "\(#function)")
        let nodeId = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"
        web3.staking.getStakingInfo(sender: sender, nodeId: nodeId) { (result, response) in
            switch result {
            case .success:
                guard let _ = response?.result else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForSubmitText() {
        let expection = self.expectation(description: "\(#function)")

        let verifier = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"
        let pIDID = String("10")

        web3.proposal.submitText(verifier: verifier, pIDID: pIDID, sender: sender, privateKey: privateKey) { (result, response) in
            switch result {
            case .success:
                guard let data = response else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
                let txHash = data.toHexString()
                print(txHash)
                XCTAssert(txHash.count > 0, "tx hash should be bot nil")
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForSubmitVersion() {
        let expection = self.expectation(description: "\(#function)")
        let verifier = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"
        let pIDID = "10"
        let newVersion = UInt32(1801)
        let eblock = UInt64(1)

        web3.proposal.submitVersion(verifier: verifier, pIDID: pIDID, newVersion: newVersion, endVotingBlock: eblock, sender: sender, privateKey: privateKey) { (result, response) in
            switch result {
            case .success:
                guard let data = response else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
                let txHash = data.toHexString()
                print(txHash)
                XCTAssert(txHash.count > 0, "tx hash should be bot nil")
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForSubmitCancel() {
        let expection = self.expectation(description: "\(#function)")

        let verifier = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"
        let pIDID = "1234567890"
        let eblock = UInt64(1)
        let tobeCanceledProposalID = "ab83a48443fc5bcb662b9f91fef7c7baa0170c5d244a4c73f3054dadbb69a27d"
        let newVersion = UInt32(1)

        web3.proposal.submitCancel(verifier: verifier, pIDID: pIDID, newVersion: newVersion, endVotingRounds: eblock, tobeCanceledProposalID: tobeCanceledProposalID, sender: sender, privateKey: privateKey) { (result, response) in
            switch result {
            case .success:
                guard let data = response else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
                let txHash = data.toHexString()
                print(txHash)
                XCTAssert(txHash.count > 0, "tx hash should be bot nil")
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForVote() {
        let expection = self.expectation(description: "\(#function)")
        let verifier = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"
        let proposalID = "0x8292a10580b0497650293b3c0c27c5ebe89e1222bd4d2ee868b9b6326522816e"
        let option = VoteOption.Yeas

        web3.proposal.vote(verifier: verifier, proposalID: proposalID, option: option, sender: sender, privateKey: privateKey) { (result, response) in
            switch result {
            case .success:
                guard let data = response else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
                let txHash = data.toHexString()
                print(txHash)
                XCTAssert(txHash.count > 0, "tx hash should be bot nil")
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testDeclareVersion() {
        let expection = self.expectation(description: "\(#function)")

        let verifier = "411a6c3640b6cd13799e7d4ed286c95104e3a31fbb05d7ae0004463db648f26e93f7f5848ee9795fb4bbb5f83985afd63f750dc4cf48f53b0e84d26d6834c20c"

        web3.proposal.declareVersion(verifier: verifier, sender: sender, privateKey: privateKey) { (result, response) in
            switch result {
            case .success:
                guard let data = response else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
                let txHash = data.toHexString()
                print(txHash)
                XCTAssert(txHash.count > 0, "tx hash should be bot nil")
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForGetProposal() {
        let expection = self.expectation(description: "\(#function)")

        let proid = "0x2ceea9176087f6fe64162b8efb2d71ffd0cc0c0326b24738bb644e71db0d5cc6"
        web3.proposal.getProposal(sender: sender, proposalID: proid) { (result, response) in
            switch result {
            case .success:
                guard let _ = response?.result else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForGetTallyResult() {
        let expection = self.expectation(description: "\(#function)")

        let proid = "0x2ceea9176087f6fe64162b8efb2d71ffd0cc0c0326b24738bb644e71db0d5cc6"
        web3.proposal.getProposalResult(sender: sender, proposalID: proid) { (result, response) in
            switch result {
            case .success:
                guard let _ = response?.result else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForlistProposal() {
        let expection = self.expectation(description: "\(#function)")

        web3.proposal.getProposalList(sender: sender) { (result, response) in
            switch result {
            case .success:
                guard let _ = response?.result else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForGetActiveVersion() {
        let expection = self.expectation(description: "\(#function)")

        web3.proposal.getActiveVersion(sender: sender) { (result, response) in
            switch result {
            case .success:
                guard let _ = response?.result else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForGetProgramVersion() {
        let expection = self.expectation(description: "\(#function)")

        web3.platon.getProgramVersion { (response) in
            print(response)
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForReportDuplicateSign() {
        let expection = self.expectation(description: "\(#function)")

        let data = "{}"
        web3.slash.reportDuplicateSign(data: data, sender: sender, privateKey: privateKey) { (result, response) in
            switch result {
            case .success:
                guard let data = response else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
                let txHash = data.toHexString()
                print(txHash)
                XCTAssert(txHash.count > 0, "tx hash should be bot nil")
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForCheckDuplicateSign() {
        let expection = self.expectation(description: "\(#function)")

        let typ = DuplicateSignType.prepare
        let addr = "0x12c171900f010b17e969702efa044d077e868082"
        let blockNumber = UInt64(1000)
        web3.slash.checkDuplicateSign(sender: sender, typ: typ, addr: addr, blockNumber: blockNumber) { (result, response) in
            switch result {
            case .success:
                guard let _ = response?.result else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForCreateRestrictingPlan() {
        let expection = self.expectation(description: "\(#function)")

        let account = "0x0772fd8e5126C01b98D3a93C64546306149202ED"
        let epoch: UInt64 = 1
        let plans = [
            RestrictingPlan(epoch: epoch, amount: BigUInt(100).multiplied(by: PlatonConfig.VON.LAT))
        ]

        let sender1 = "0xA7074774f4E1e033c6cBd471Ec072f7734144A0c"
        let pri1 = "77bc96ef72034937da4c2a23162c3261df543d0c0d2a80fd9cddb9951762886a"
        web3.restricting.createRestrictingPlan(
            account: account,
            plans: plans,
            sender: sender1,
            privateKey: pri1) { (result, response) in
                switch result {
                case .success:
                    guard let data = response else {
                        XCTAssert(false, "response should be not nil")
                        return
                    }
                    let txHash = data.toHexString()
                    print(txHash)
                    XCTAssert(txHash.count > 0, "tx hash should be bot nil")
                case .fail(_, let error):
                    XCTAssert(false, error ?? "send tx fail")
                }
                expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }

    func testForGetRestrictingInfo() {
        let expection = self.expectation(description: "\(#function)")

        let account = "0x0772fd8e5126C01b98D3a93C64546306149202ED"
        let sender1 = "0xA7074774f4E1e033c6cBd471Ec072f7734144A0c"
        web3.restricting.getRestrictingPlanInfo(sender: sender1, account: account) { (result, response) in
            switch result {
            case .success:
                guard let _ = response?.result else {
                    XCTAssert(false, "response should be not nil")
                    return
                }
            case .fail(_, let error):
                XCTAssert(false, error ?? "send tx fail")
            }
            expection.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
}
