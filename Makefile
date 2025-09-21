-include .env


build:; forge build

create :
	forge create FundMe --rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_PRIVATE_KEY) --broadcast 
