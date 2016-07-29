import Reveal

import Quick
import Nimble

class ZipSpec: QuickSpec {
    override func spec() {
        describe("Zipping basic intermediates") {
            var counter = 0
            var node1 = ActiveNode<Int>()
            
            var node2 = ActiveNode<Double>()
            
            var stream1 = ActiveStream<Int>()
            var stream2 = ActiveStream<Double>()
            
//            var operation1 = ActiveOperation<Int, TestError1>()
//            var operation2 = ActiveOperation<Double, TestError2>()
            
            beforeEach {
                counter = 0
                
                node1 = ActiveNode<Int>()
                node2 = ActiveNode<Double>()
                
                stream1 = ActiveStream<Int>()
                stream2 = ActiveStream<Double>()
                
//                operation1 = ActiveOperation<Int, TestError1>()
//                operation2 = ActiveOperation<Double, TestError2>()
            }
            
            it("should receive value for correct times from zipped nodes") {
                combine(.zip, node1, node2).subscribe { _ in
                    counter += 1
                }
                
                node1.send(1)
                node2.send(1.0)
                expect(counter).to(equal(1))
                
                node1.send(1)
                node1.send(1)
                expect(counter).to(equal(1))
                
                node2.send(1.0)
                expect(counter).to(equal(2))
                
                node2.send(1.0)
                expect(counter).to(equal(3))
                
                node2.send(1.0)
                expect(counter).to(equal(3))
                
                node1.send(1)
                expect(counter).to(equal(4))
            }
            
            it("should receive value for correct times from zipped streams") {
                combine(.zip, stream1, stream2).subscribe { pair in
                    counter += 1
                }
                
                stream1.sendNext(1)
                stream2.sendNext(1.0)
                expect(counter).to(equal(1))

                stream1.sendNext(1)
                stream1.sendNext(1)
                expect(counter).to(equal(1))
                
                stream2.sendNext(1.0)
                expect(counter).to(equal(2))
                
                stream2.sendNext(1.0)
                expect(counter).to(equal(3))
                
                stream2.sendNext(1.0)
                expect(counter).to(equal(3))
                
                stream1.sendNext(1)
                expect(counter).to(equal(4))
                
                stream1.sendLast(1)
                expect(counter).to(equal(4))
                
                stream2.sendNext(1.0)
                expect(counter).to(equal(6)) // .next & .completed
                
                stream1.sendNext(1)
                expect(counter).to(equal(6))
                
                stream2.sendNext(1.0)
                expect(counter).to(equal(6))
            }
        }
    }
}

struct TestError1: ErrorType {
    
}

struct TestError2: ErrorType {
    
}