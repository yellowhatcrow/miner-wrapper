#!/bin/bash
# Miner Wrapper v1.0.1
#
#

option=$1
pid_dir="run"
pid_file="${pid_dir}/miner.pid"
config="miner_wrapper.cfg"

perror(){
        [ -z "${1}" ] && msg="${1}" || msg="Unknown Error occurred!"
        printf "\033[35mError:\033[0m\t\033[31m${msg}\033[0m\n"
        }

rerun_config(){
	printf "\033[33mRerun the configuration file!\033[0m\n"
	}

start(){
	# Set from configuration file.
	mining_tool=$1
        port=$2
        pool_address=$3
        wallet_address=$4
        worker=$5
        api_bind=$6
	if [ -z "$mining_tool" ];
	then
		perror "Missing 'mining tool'!"
		exit 1
	fi

	if [ -z "$port" ];
	then
		perror "Missing 'pool port'!"
		exit 1
	fi

	if [ -z "$wallet_address" ];
	then
		perror "Missing your 'wallet address'!"
		exit 1
	fi

	if [ -z "$api_bind" ];
	then
		perror "Missing 'api bind'!"
		exit 1
	fi

        # Start miner process in background
        case "${worker}" in
        	empty) nohup $mining_tool -a cryptonight -o ${pool_address}:${port} -u ${wallet_address} --api-bind ${api_bind} & ;;
		*) nohup $mining_tool --quiet -a cryptonight -o ${pool_address}:${port} -u ${wallet_address} -p ${worker} -t 1 --api-bind ${api_bind} & ;;
        esac
        # Store process id
        _pid=($(pgrep $mining_tool))
        # Create Process Directory
        if [ ! -d "${pid_dir}" ];
        then
                mkdir -v "${pid_dir}"
        fi
        # Get Last Miner process id
        if [ ${#_pid[*]} -gt 1 ];
        then
                printf "Running PID: ${_pid[1]}\n"
                run_level=1
        else
                printf "Running PID: ${_pid[0]}\n"
                run_level=0
        fi
        printf "${_pid[$run_level]}" > $pid_file
        }

kill_miner(){
        if [ -f "$pid_file" ];
        then
		if [ ! -z "$(cat $pid_file)" ];
		then
                	kill -9 `cat $pid_file`
		fi
                rm $pid_file
        else
                perror "No Miner tool process was found!"
        fi
        }

help_meu(){
	printf "\033[36mMiner Wrapper\033[0m\n"
	printf "\033[35mStart Miner\033[0m\t\033[32m[ -s, -start ]\033[0m\n"
	printf "\033[35mKill Miner\033[0m\t\033[32m[ -k, -kill ]\033[0m\n"
	printf "\033[35mView Config\033[0m\t\033[32m[ -v, -view ]\033[0m\n"
	printf "\033[35mHelp Menu\033[0m\t\033[32m[ -h, -help ]\033[0m\n"
	}

case $option in
        -s|-start)
                if [ ! -f $pid_file ];
                then
			__mining_tool="$(grep 'miner:' $config | cut -d: -f2 )"
        		__port="$(grep 'port:' $config | cut -d: -f2)"
        		__pool_address="$(grep 'pool_address:' $config | cut -d: -f2)"
        		__wallet_address="$(grep 'wallet_address:' $config | cut -d: -f2)"
      			__worker="$(grep 'worker_name:' $config | cut -d: -f2)"
        		__api_bind="$(grep 'api_bind:' $config | cut -d: -f2)"
                        start "$__mining_tool" "$__port" "$__pool_address" "$__wallet_address" "$__worker" "$__api_bind"
                else
                        printf "\033[32mMiner Tool is already running\033[0m\n"
                        printf "\033[35mPID:\033[0m \033[36m$(cat $pid_file)\033[0m\n"
                fi
        ;;
	-v|-view)
	__mining_tool="$(grep 'miner:' $config | cut -d: -f2 )"
        __port="$(grep 'port:' $config | cut -d: -f2)"
        __pool_address="$(grep 'pool_address:' $config | cut -d: -f2)"
        __wallet_address="$(grep 'wallet_address:' $config | cut -d: -f2)"
      	__worker="$(grep 'worker_name:' $config | cut -d: -f2)"
        __api_bind="$(grep 'api_bind:' $config | cut -d: -f2)"
	printf "\033[35mMining Tool:\033[0m\t\033[32m$__mining_tool\033[0m\n"
	printf "\033[35mPort:\033[0m\t\t\033[32m$__port\033[0m\n"
	printf "\033[35mPool Address:\033[0m\t\033[32m$__pool_address\033[0m\n"
	printf "\033[35mWallet Address:\033[0m\t\033[32m$__wallet_address\033[0m\n"
	printf "\033[35mWorker:\033[0m\t\t\033[32m$__worker\033[0m\n"
	printf "\033[35mAPI Bind:\033[0m\t\033[32m$__api_bind\033[0m\n"
	;;
        -k|-kill) kill_miner;;
	-h|-help) help_menu;;
        *) printf "Err: \033[31mMissing or invalid parameter was given!\033[0m\n";;
esac
