module varshi_add::MultiTokenManager {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::vector;
    use std::string::String;


    struct TokenManager has store, key {
        token_balances: vector<u64>,    
        token_names: vector<String>,    
        total_tokens: u64,              
    }

   
    const E_TOKEN_MANAGER_NOT_EXISTS: u64 = 1;
    const E_INVALID_TOKEN_INDEX: u64 = 2;
    const E_INSUFFICIENT_BALANCE: u64 = 3;

    
    public fun initialize_manager(owner: &signer) {
        let manager = TokenManager {
            token_balances: vector::empty<u64>(),
            token_names: vector::empty<String>(),
            total_tokens: 0,
        };
        move_to(owner, manager);
    }

    
    public fun register_and_deposit_token(
        owner: &signer, 
        token_name: String, 
        initial_amount: u64
    ) acquires TokenManager {
        let owner_addr = signer::address_of(owner);
        let manager = borrow_global_mut<TokenManager>(owner_addr);
        
        
        vector::push_back(&mut manager.token_names, token_name);
        vector::push_back(&mut manager.token_balances, initial_amount);
        manager.total_tokens = manager.total_tokens + 1;
        
        
        let deposit = coin::withdraw<AptosCoin>(owner, initial_amount);
        coin::deposit<AptosCoin>(owner_addr, deposit);
    }

}
