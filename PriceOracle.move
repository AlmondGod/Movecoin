address 0x0 {
module PriceOracle {
    use Std::Signer;

    struct PriceFeed has key {
        price: u64,
    }

    const AUTHORIZED_UPDATER: address;

    public fun initialize(account: &signer, initial_price: u64) {
        AUTHORIZED_UPDATER = account;

        let price_feed = PriceFeed { price: initial_price };
        move_to(account, price_feed);
    }

    public fun update_price(account: &signer, new_price: u64) {
        //same as above
        assert(Signer::address_of(account) == AUTHORIZED_UPDATER, 2);

        let price_feed = borrow_global_mut<PriceFeed>(Signer::address_of(account));
        price_feed.price = new_price;
    }

    public fun get_current_price(): u64 {
        let price_feed = borrow_global<PriceFeed>(AUTHORIZED_UPDATER);
        price_feed.price
    }
}
}
