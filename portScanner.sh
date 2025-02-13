#!/bin/bash

# Script to scan tcp port on a IP address so you dont loose your multipass vm instances
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
RESET="\033[0m"
MIN=1
MAX=65535



# How to use port scanning utility
manual(){
  echo -e "${RED}How to use port scanner utility${RESET}" 
  echo -e "${RED}Pass IP Adress and starting port and ending port${RESET}"
  echo -e "${GREEN}Example:${RESET} ${RED}./portScanner 127.0.0.1 4000 5000${RESET}"
  exit 1
}

# Install netcat
installNetcat() {
  echo -e "${BLUE}Installing netcat...${RESET}"
  sudo apt install -y netcat > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}Netcat installed successfully.${RESET}"
  else
    echo -e "${RED}Failed to install netcat. Exiting...${RESET}"
    exit 1
  fi
}

# Scan the ports
scan() {
  local ip=$1
  local start=$2
  local end=$3

  # Ensure start is less than or equal to end
  if [[ $start -gt $end ]]; then
    local temp=$start
    start=$end
    end=$temp
  fi

  # Ensure start and end are within the range of valid ports
  if [[ $start -lt $MIN ]]; then
    start=$MIN
    echo -e "setting start port to $MIN"
  fi
  
  if
     [[ $end -gt $MAX ]]; then
      start=$MAX
      echo -e "setting end port to $MAX"
  fi

  echo -e "${BLUE}Scanning ports on $ip from $start to $end...${RESET}"

  for ((i = start; i <= end; i++)); do
    nc -z -v "$ip" "$i" 2>/dev/null
    if [[ $? -eq 0 ]]; then
      echo -e "${GREEN}Port $i is open${RESET}"
    fi
  done
}


# Check if netcat is installed if not install it
utilityCheck() {
  echo -e "${RED}Checking for netcat installation...${RESET}"
  if ! command -v nc &> /dev/null; then
    installNetcat
    if [[ $? -ne 0 ]]; then
      echo -e "${RED}Failed to install netcat. Exiting...${RESET}"
      exit 1
    fi
  fi
  echo -e "${GREEN}Netcat is installed${RESET}"
  return 0
}



if [[ $# -ne 3 ]]; then
  manual
fi

utilityCheck
scan "$1" "$2" "$3"
