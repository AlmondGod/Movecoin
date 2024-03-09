address 0x0 {
module Policy {
    use 0x0::Stablecoin;
    use 0x0::PriceOracle;

    const TARGET_PRICE: u64 = 100; 

    public fun check_mint_policy(): bool {
        let current_price = PriceOracle::get_current_price();
        
        //allow minting if we want more supply to decrease price of Movecoin
        if (current_price < TARGET_PRICE) {
            return false;
        } else {
            return true;
        }
    }

    public fun check_burn_policy(): bool {
        let current_price = PriceOracle::get_current_price();
        
        //allow burning if we want less supply to increase price of Movecoin
        if (current_price > TARGET_PRICE) {
            return false;
        } else {
            return true;
        }
    }
}
}
