module varshi_add::MultiTokenManager {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::vector;
    use std::string::String;

    /// Struct representing a multi-token manager for an account
    struct TokenManager has store, key {
        token_balances: vector<u64>,    // Balances of different token types
        token_names: vector<String>,    // Names of registered token types
        total_tokens: u64,              // Total number of different token types managed
    }

    /// Error codes
    const E_TOKEN_MANAGER_NOT_EXISTS: u64 = 1;
    const E_INVALID_TOKEN_INDEX: u64 = 2;
    const E_INSUFFICIENT_BALANCE: u64 = 3;

    /// Function to initialize a new token manager for an account
    public fun initialize_manager(owner: &signer) {
        let manager = TokenManager {
            token_balances: vector::empty<u64>(),
            token_names: vector::empty<String>(),
            total_tokens: 0,
        };
        move_to(owner, manager);
    }

    /// Function to register a new token type and deposit initial amount
    public fun register_and_deposit_token(
        owner: &signer, 
        token_name: String, 
        initial_amount: u64
    ) acquires TokenManager {
        let owner_addr = signer::address_of(owner);
        let manager = borrow_global_mut<TokenManager>(owner_addr);
        
        // Add new token type
        vector::push_back(&mut manager.token_names, token_name);
        vector::push_back(&mut manager.token_balances, initial_amount);
        manager.total_tokens = manager.total_tokens + 1;
        
        // Withdraw AptosCoin as representation of token deposit
        let deposit = coin::withdraw<AptosCoin>(owner, initial_amount);
        coin::deposit<AptosCoin>(owner_addr, deposit);
    }
}