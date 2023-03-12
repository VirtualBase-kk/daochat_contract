const DAOCHAT_contract = artifacts.require("DAOCHAT")

contract("DAOCHAT",accounts=>{
    let contract
    describe("init",async()=>{
        beforeEach(async()=>{
            contract = await DAOCHAT_contract.new("MZ DAO",{from:accounts[0]});
        })  
        it("getName",async()=>{
            const actual = await contract.GetName()
            assert.equal(actual,"MZ DAO","Get Name Error")
        })
        
        it("add Admin Member by owner account",async() => {
            const actual = await contract.AddMember(accounts[1],{from:accounts[0]})
            assert(actual,"Add Member Error")
        })

        it("add Admin Member by other account", async()=>{
            try {
                const actual = await contract.AddMember(accounts[1],{from:accounts[2]})
            } catch (error) {
                return;
            }   
            assert.fail("Add member Permission missing")
        })

        it("add Admin Member by new account",async()=>{
            await contract.AddMember(accounts[1],{from:accounts[0]})
            const actual = await contract.AddMember(accounts[2],{from:accounts[1]})
            assert(actual,"Add Member Error")
        })

        it("delete Admin Member by true account",async()=>{
            await contract.AddMember(accounts[1],{from:accounts[0]})
            const actual = await contract.DeleteAdminMember(accounts[1],{from:accounts[0]})
            assert(actual,"Delete Member Error")
        })
        
        it("delete Admin Member by owner account",async()=>{
            try {
                const actual = await contract.AddMember(accounts[0],{from:accounts[2]})
            } catch (error) {
                return;
            }   
            assert.fail("Delete member Permission missing")
        })

        it("delete Admin own account",async()=>{
            try {
                await contract.AddMember(accounts[1],{from:accounts[0]})
                const actual = await contract.DeleteAdminMember(accounts[1],{from:accounts[1]})
            } catch (error) {
                return;
            }   
            assert.fail("Delete member Permission missing")
        })

        it("AddVote by true account",async()=>{
            const actual = await contract.AddVote("id1","投票1",["choice1","choice2","choice3"],{from:accounts[0]})
            assert(actual,"Add vote error")
        })

        it("AddVote by other account",async()=>{
            try {
                const actual = await contract.AddVote("id1","投票1",["choice1","choice2","choice3"],{from:accounts[1]})
            } catch (error) {
                return;
            }   
            assert.fail("Add vote error")
        })

        it("Get Vote list",async()=>{
            await contract.AddVote("id1","投稿1",["choice1","choice2","choice3"],{from:accounts[0]})
            await contract.AddVote("id2","投稿2",["choice1","choice2","choice3"],{from:accounts[0]})
            const actual = await contract.GetVotes()            
            assert.equal(JSON.stringify(actual),JSON.stringify({"0":["id1","id2"],"1":["投稿1","投稿2"],ids:["id1","id2"],titles:["投稿1","投稿2"]}))
        })

        it("Add answer",async()=>{
            await contract.AddVote("id1","投票1",["choice1","choice2","choice3"],{from:accounts[0]})
            const actual = await contract.AddAnswer("id1",["choice1","choice2","choice3"],[10,20,30],{from:accounts[0]})
            assert(actual)
        })
        it("get choice",async()=>{
            await contract.AddVote("id1","投票1",["choice1","choice2","choice3"],{from:accounts[0]})
            const actual = await contract.GetChoices("id1",{from:accounts[0]})            
            assert.equal(JSON.stringify(actual),JSON.stringify([ 'choice1', 'choice2', 'choice3' ]))
        })

        it("get result",async()=>{
            const answer = [10,20,30]
            const choice = ["choice1","choice2","choice3"]
            await contract.AddVote("id1","投票1",["choice1","choice2","choice3"],{from:accounts[0]})
            await contract.AddAnswer("id1",["choice1","choice2","choice3"],[10,20,30],{from:accounts[0]})
            const actual = await contract.GetResult("id1",3,{from:accounts[0]})        
            actual.results.forEach((item,index)=>{
                if (item.toNumber() !== answer[index]) {
                    assert.fail("answer")
                }
            })
            actual.ids.forEach((item,index)=>{
                if (item !== choice[index]) {
                    assert.fail("choice")
                }
            })
            assert(actual)
        })

        it("get choice count",async()=>{
            await contract.AddVote("id1","投票1",["choice1","choice2","choice3"],{from:accounts[0]})
            const actual = await contract.GetChoiceCount("id1",{from:accounts[0]})
            assert.equal(actual,3)
        })
    })

})