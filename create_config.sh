#!/bin/bash

config_file="miner_wrapper.cfg"

clean_config(){
	if [ -f "$config_file" ];
	then
		rm -v $config_file
	else
		printf "\033[33mErr:\033[0m\t\033[31mUnable to locate: ${config_file}!\033[0m\n"
	fi
	}

if [ -f "$config_file" ];
then
	printf "\033[35mWARNING:\033[0m\t\033[31mGoing further will remove older configuration!\033[0m\n"
	read -p "Are you sure?[yes|no] " _confirm
	case $_confirm in
		yes|Yes|y|Yes|YES) rm $config_file;;
		no|No|n|NO) printf "Exiting, nothing to process\n" && exit 0;;
	esac
fi

# MINER'S Tool
until [ ! -z "$mining_tool" -o "$mining_tool" = 'q' ];
do
	read -p "Name of Mining Tool: " mining_tool
done
[ "$mining_tool" = 'q' ] && clean_config
printf "miner: $mining_tool\n" | tee $config_file

# POOL PORT
until [ ! -z "$port" -o "$port" = 'q' ];
do
	read -p "Set Pool Port: " port
done
[ "$port" = 'q' ] && clean_config
printf "port: $port\n" | tee -a $config_file

# POOL ADDRESS
until [ ! -z "$pool_address" -o "$pool_address" = 'q' ];
do
	read -p "Set Pool Address: " pool_address
done
[ "$pool_address" = 'q' ] && clean_config
printf "pool_address: $pool_address\n" | tee -a $config_file

# WALLET ADDRESS
until [ ! -z "$wallet_address" -o "$wallet_address" = 'q' ];
do
	read -p "Set Wallet Address: " wallet_address
done
[ "$wallet_address" = 'q' ] && clean_config
printf "wallet_address: $wallet_address\n" | tee -a $config_file

# WORKER NAME
until [ ! -z "$worker_name" -o "$worker_name" = 'q' ];
do
	read -p "Set Worker if Required: " worker_name
done
[ "$worker_name" = 'q' ] && clean_config
printf "worker_name: $worker_name\n" | tee -a $config_file

# API BIND
until [ ! -z "$api_bind" -o "$api_bind" = 'q' ];
do
	read -p "Set API Bind: " api_bind
done
[ "$api_bind" = 'q' ] && clean_config
printf "api_bind: $api_bind\n" | tee -a $config_file


printf "\033[32mDone!\033[0m\n"
