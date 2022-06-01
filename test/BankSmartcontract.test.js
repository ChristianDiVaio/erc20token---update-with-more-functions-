const Token = artifacts.required("BankSmartContract");

var chai = require("chai");
const BN = web3.utils.BN;
const chaiBN = require("chai-bn")(BN);
chai.use(chaiBN);

var chaiAspromised = require("chai-as-promised");
const { iteratee } = require("lodash");
chai.use(chaiAspromised);

const expect = chai.expect;

contract("BankSmartContract", async (accounts) => {
    const [deployerAccount, investorsAccount1, investorsAccount2, investorsAccount3] = accounts;

    const name= 'erc20token';
    const symbol = 'ESC';

    const initialSupply = new BN(100); 

    beforeEach(async () => {
        nativeToken = await NativeToken.new(erc20token, ESCsymbol, intialHolder, initialSupply);
    });

    it('has a name', async function () {
        expect(await this.token.name()).to.equal(symbol);
    });

    it('has 18 decimals', async function () {
        expect(await this.token.decimals()).to.be.bignumber.equal('18');
    });

    describe('set decimals', function () {
        const decimals = new BN();

        it ('can set decimals during construction', async function () {
            const token = await ERC20DecimalsMock.new(name, symbol, decimals);
            expect(await token.decimals()).to.be.bignumber.equal(decimals);
        });
    });


    // Deployment of Tokens 
    describe("Deployment", () => {
        let result
        it('Tracks the name, symbol and decimals', async () => {
            result = await nativeToken.name()
            result.should.equal(name)
            console.log('Token name is ' + result)

            result = await nativeToken.symbol()
            result.should.equal(symbol)
            console.log('Token symbol is ' + result)

            result = await nativeToken.decimals()
            result.toString().should.equal(decimals)
            console.log('Decimals are ' + result.toString())
        })
    })



    //shouldBehaveLikeERC20('ERC20', initialSupply, initialHolder, receipient, anotherAccount);

    describe('Balance of Tokens, approving and staking allowance', function () {
        describe('when the spender is not the zero address', function () {
            const spender = recipient;

            function shouldDecreaseApproval (amount) {
                describe('when there was no approved before', function () {
                    it('reverts', async function () {
                        await expectRevert(this.token.decreaseAllowance(
                            spender, amount, { from: initialHolder }), 'ERC20: decreased allowance below zero',
                        );

                        });
                    });

            //approved amount for staking 

            describe('when the spender had and approved amount', function () {
                    const approvedAmount = amount;

                    beforeEach(async function () {
                        await this.token.approve(spender, approvedAmount, { from: initialHolder });
                        'Approval',
                        { owner: initialHolder, spender: spender, value: new BN(0) },
                    });
                });

                    it('emits an approval event', async function () {
                        expectEvent(
                            await this.token.decreaseAllowance(spender, approvedAmount, { from: initialholder }),
                            'Approval',
                            { owner: initialHolder, spender: spender, value: new BN(0) },
                        );
                    });

            //transfer from account for staking 
            describe('_transfer', () => {
                    shoudlBehaveLikeERC20Transfer('ERC20', initialHolder, receipient, initialSupply, function (from, to, amount) {
                        return this.token.transferInternal(from, to, amount);
                        });
                    })

            //transfer from account for staking 
            describe('_transfer', () => {
                    shoudlBehaveLikeERC20Transfer('ERC20', initialHolder, receipient, initialSupply, function (from, to, amount) {
                        return this.token.transferInternal(from, to, amount);
                        });
                    })

            //transfer from account for staking 
            describe('_transfer', () => {
                    shoudlBehaveLikeERC20Transfer('ERC20', initialHolder, receipient, initialSupply, function (from, to, amount) {
                        return this.token.transferInternal(from, to, amount);
                        });
                    })

            });
        });  
    })
            


   
