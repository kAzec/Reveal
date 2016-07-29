@testable import Reveal

import Quick
import Nimble

class PropertySpec: QuickSpec {
    override func spec() {
        var property1: Property<Int>!
        var property2: Property<Int>!
        
        beforeEach {
            property1 = Property<Int>(0)
            property2 = Property<Int>(1)
        }
        
        describe("Producer of property") {
            it("should emit current value on start") {
                property1.producer()
            }
        }
        
        describe("The one-way binding of property") {
            it("should have correct values") {
                let relationship = property1 ~>> property2
                expect(property2.value).to(equal(property1.value))
                
                property1.value = 100
                expect(property2.value).to(equal(property1.value))
                
                relationship.dispose()
                
                property1.value = 200
                expect(property2.value).toNot(equal(property1.value))
            }
        }
        
        describe("The two-way binding of property") {
            it("should have correct values") {
                let relationship = property1 ~>< property2
                expect(property2.value).to(equal(property1.value))
                
                property1.value = 100
                expect(property2.value).to(equal(property1.value))
                
                property2.value = 200
                expect(property1.value).to(equal(property2.value))
                
                relationship.dispose()
                
                property1.value = 300
                expect(property2.value).toNot(equal(property1.value))
                
                property2.value = 400
                expect(property1.value).toNot(equal(property2.value))
            }
        }
        
        describe("Zipped property") {
            it("should receive values correctly") {
                var counter = 0
                combine(.zip, property1, property2).subscribe { _ in
                    counter += 1
                }
                
                property1.value = 0
                property2.value = 0
                expect(counter).to(equal(1))
                
                property1.value = 0
                property2.value = 0
                expect(counter).to(equal(2))
            }
        }
    }
}
