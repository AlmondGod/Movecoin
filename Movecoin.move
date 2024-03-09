address 0x0 {
module Movecoin::movecoin {
    use 0x0::Policy;
    use Std::Signer;

    struct MoveCoin has key, drop {
        balance: u64,
        owner: address,
    }

    struct MintCapability has key {
        mint: bool
    }

    public fun initialize(account: &signer) {
        let initial_balance = MoveCoin { balance: 0, owner: Signer::address_of(account) };
        move_to(account, initial_balance);

        //give intitializer mint (and burn) capability
        let mint_cap = MintCapability { _minter: true };
        move_to(account, mint_cap);
    }

    public fun mint(account: &signer, amount: u64) {
        //aborts if no MintCapability resource in address
        if(Policy::check_mint_policy()) {
            MintCapability::borrow_global<MintCapability>(Signer::address_of(account));
            let coin = borrow_global_mut<MoveCoin>(Signer::address_of(account));
            coin.balance = coin.balance + amount;
        }
    }

    public fun burn(account: &signer, amount: u64) {
        //same as above
        if(Policy::check_burn_policy()) {
            MintCapability::borrow_global<MintCapability>(Signer::address_of(account));
            let coin = borrow_global_mut<MoveCoin>(Signer::address_of(account));
            coin.balance = coin.balance - amount;
        }
    }

    public fun transfer(from: &signer, to: address, amount: u64) {
        let coin_from = borrow_global_mut<MoveCoin>(Signer::address_of(from));
        assert(coin_from.balance >= amount, 2); 

        //need to make sure to address has movecoin resource, if not we have to add
        if (!Std::exists<MoveCoin>(to)) {
            Self::initialize_for_recipient(to);
        }

        let coin_to = borrow_global_mut<MoveCoin>(to);

        coin_from.balance = coin_from.balance - amount;
        coin_to.balance = coin_to.balance + amount;
    }

    //add the movecoin resource
    public fun initialize_for_recipient(addr: address) {
        assert(!Std::exists<MoveCoin>(addr), 4); 
        let new_coin = MoveCoin { balance: 0, owner: addr };
        Std::move_to<MoveCoin>(addr, new_coin);
    }
}
}