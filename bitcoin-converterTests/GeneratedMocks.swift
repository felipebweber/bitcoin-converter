// MARK: - Mocks generated from file: bitcoin-converter/Model/CoinManager.swift at 2020-05-23 00:50:34 +0000

//
//  CoinManager.swift
//  BTConverter
//
//  Created by Felipe Weber on 15/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import Cuckoo
@testable import bitcoin_converter

import CoreData
import Foundation
import UIKit


 class MockCoinManagerDelegate: CoinManagerDelegate, Cuckoo.ProtocolMock {
    
     typealias MocksType = CoinManagerDelegate
    
     typealias Stubbing = __StubbingProxy_CoinManagerDelegate
     typealias Verification = __VerificationProxy_CoinManagerDelegate

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CoinManagerDelegate?

     func enableDefaultImplementation(_ stub: CoinManagerDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func didUpdatePrice(price: String, currency: String)  {
        
    return cuckoo_manager.call("didUpdatePrice(price: String, currency: String)",
            parameters: (price, currency),
            escapingParameters: (price, currency),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.didUpdatePrice(price: price, currency: currency))
        
    }
    

	 struct __StubbingProxy_CoinManagerDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func didUpdatePrice<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(price: M1, currency: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, String)> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: price) { $0.0 }, wrap(matchable: currency) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCoinManagerDelegate.self, method: "didUpdatePrice(price: String, currency: String)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_CoinManagerDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func didUpdatePrice<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(price: M1, currency: M2) -> Cuckoo.__DoNotUse<(String, String), Void> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: price) { $0.0 }, wrap(matchable: currency) { $0.1 }]
	        return cuckoo_manager.verify("didUpdatePrice(price: String, currency: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class CoinManagerDelegateStub: CoinManagerDelegate {
    

    

    
     func didUpdatePrice(price: String, currency: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}



 class MockCoinManager: CoinManager, Cuckoo.ClassMock {
    
     typealias MocksType = CoinManager
    
     typealias Stubbing = __StubbingProxy_CoinManager
     typealias Verification = __VerificationProxy_CoinManager

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CoinManager?

     func enableDefaultImplementation(_ stub: CoinManager) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     override var delegate: CoinManagerDelegate? {
        get {
            return cuckoo_manager.getter("delegate",
                superclassCall:
                    
                    super.delegate
                    ,
                defaultCall: __defaultImplStub!.delegate)
        }
        
        set {
            cuckoo_manager.setter("delegate",
                value: newValue,
                superclassCall:
                    
                    super.delegate = newValue
                    ,
                defaultCall: __defaultImplStub!.delegate = newValue)
        }
        
    }
    
    
    
     override var coinApiTeste: CoinAPI {
        get {
            return cuckoo_manager.getter("coinApiTeste",
                superclassCall:
                    
                    super.coinApiTeste
                    ,
                defaultCall: __defaultImplStub!.coinApiTeste)
        }
        
        set {
            cuckoo_manager.setter("coinApiTeste",
                value: newValue,
                superclassCall:
                    
                    super.coinApiTeste = newValue
                    ,
                defaultCall: __defaultImplStub!.coinApiTeste = newValue)
        }
        
    }
    
    
    
     override var manageResult: NSFetchedResultsController<CoinEntity>? {
        get {
            return cuckoo_manager.getter("manageResult",
                superclassCall:
                    
                    super.manageResult
                    ,
                defaultCall: __defaultImplStub!.manageResult)
        }
        
        set {
            cuckoo_manager.setter("manageResult",
                value: newValue,
                superclassCall:
                    
                    super.manageResult = newValue
                    ,
                defaultCall: __defaultImplStub!.manageResult = newValue)
        }
        
    }
    
    
    
     override var context: NSManagedObjectContext {
        get {
            return cuckoo_manager.getter("context",
                superclassCall:
                    
                    super.context
                    ,
                defaultCall: __defaultImplStub!.context)
        }
        
    }
    

    

    
    
    
     override func fetchCoinPrice()  {
        
    return cuckoo_manager.call("fetchCoinPrice()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.fetchCoinPrice()
                ,
            defaultCall: __defaultImplStub!.fetchCoinPrice())
        
    }
    
    
    
     override func parseJSON(_ dictionary: Dictionary<String, Any>)  {
        
    return cuckoo_manager.call("parseJSON(_: Dictionary<String, Any>)",
            parameters: (dictionary),
            escapingParameters: (dictionary),
            superclassCall:
                
                super.parseJSON(dictionary)
                ,
            defaultCall: __defaultImplStub!.parseJSON(dictionary))
        
    }
    

	 struct __StubbingProxy_CoinManager: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var delegate: Cuckoo.ClassToBeStubbedOptionalProperty<MockCoinManager, CoinManagerDelegate> {
	        return .init(manager: cuckoo_manager, name: "delegate")
	    }
	    
	    
	    var coinApiTeste: Cuckoo.ClassToBeStubbedProperty<MockCoinManager, CoinAPI> {
	        return .init(manager: cuckoo_manager, name: "coinApiTeste")
	    }
	    
	    
	    var manageResult: Cuckoo.ClassToBeStubbedOptionalProperty<MockCoinManager, NSFetchedResultsController<CoinEntity>> {
	        return .init(manager: cuckoo_manager, name: "manageResult")
	    }
	    
	    
	    var context: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockCoinManager, NSManagedObjectContext> {
	        return .init(manager: cuckoo_manager, name: "context")
	    }
	    
	    
	    func fetchCoinPrice() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCoinManager.self, method: "fetchCoinPrice()", parameterMatchers: matchers))
	    }
	    
	    func parseJSON<M1: Cuckoo.Matchable>(_ dictionary: M1) -> Cuckoo.ClassStubNoReturnFunction<(Dictionary<String, Any>)> where M1.MatchedType == Dictionary<String, Any> {
	        let matchers: [Cuckoo.ParameterMatcher<(Dictionary<String, Any>)>] = [wrap(matchable: dictionary) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCoinManager.self, method: "parseJSON(_: Dictionary<String, Any>)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_CoinManager: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var delegate: Cuckoo.VerifyOptionalProperty<CoinManagerDelegate> {
	        return .init(manager: cuckoo_manager, name: "delegate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var coinApiTeste: Cuckoo.VerifyProperty<CoinAPI> {
	        return .init(manager: cuckoo_manager, name: "coinApiTeste", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var manageResult: Cuckoo.VerifyOptionalProperty<NSFetchedResultsController<CoinEntity>> {
	        return .init(manager: cuckoo_manager, name: "manageResult", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var context: Cuckoo.VerifyReadOnlyProperty<NSManagedObjectContext> {
	        return .init(manager: cuckoo_manager, name: "context", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func fetchCoinPrice() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("fetchCoinPrice()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func parseJSON<M1: Cuckoo.Matchable>(_ dictionary: M1) -> Cuckoo.__DoNotUse<(Dictionary<String, Any>), Void> where M1.MatchedType == Dictionary<String, Any> {
	        let matchers: [Cuckoo.ParameterMatcher<(Dictionary<String, Any>)>] = [wrap(matchable: dictionary) { $0 }]
	        return cuckoo_manager.verify("parseJSON(_: Dictionary<String, Any>)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class CoinManagerStub: CoinManager {
    
    
     override var delegate: CoinManagerDelegate? {
        get {
            return DefaultValueRegistry.defaultValue(for: (CoinManagerDelegate?).self)
        }
        
        set { }
        
    }
    
    
     override var coinApiTeste: CoinAPI {
        get {
            return DefaultValueRegistry.defaultValue(for: (CoinAPI).self)
        }
        
        set { }
        
    }
    
    
     override var manageResult: NSFetchedResultsController<CoinEntity>? {
        get {
            return DefaultValueRegistry.defaultValue(for: (NSFetchedResultsController<CoinEntity>?).self)
        }
        
        set { }
        
    }
    
    
     override var context: NSManagedObjectContext {
        get {
            return DefaultValueRegistry.defaultValue(for: (NSManagedObjectContext).self)
        }
        
    }
    

    

    
     override func fetchCoinPrice()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func parseJSON(_ dictionary: Dictionary<String, Any>)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

