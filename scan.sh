#!/bin/bash
# Coded by Monkey B Luffy
# https://github.com/florienzh4x
# Special Thanks for Rinto AR

token(){
	GetToken=$(sudo service tor reload | torify curl -s --compressed "https://cse.google.com/cse.js?cx=partner-pub-2698861478625135:3033704849" -L -D -)
	token=$(echo $GetToken | grep -Po "(?<=\"cse_token\": \")[^\"]*")
}
Dorking(){
	token
	key="partner-pub-2698861478625135:3033704849"
    Dorking=$(sudo service tor reload | torify curl -s --compressed 'https://cse.google.com/cse/element/v1?num=10&hl=en&cx='''"${key}"'''&safe=off&cse_tok='''"${token}"'''&start='''"${2}"'''&q='''"${1}"'''&callback=x' -L -D - | grep -Po '(?<="unescapedUrl": ")[^"]*')
}
mDorking(){
	token
	key="partner-pub-2698861478625135:3033704849"
    Dorking=$(sudo service tor reload | torify curl -s --compressed 'https://cse.google.com/cse/element/v1?num=10&hl=en&cx='''"${key}"'''&safe=off&cse_tok='''"${token}"'''&start='''"${2}"'''&q='''"${1}"'''&callback=x' -L -D - | grep -Po '(?<="unescapedUrl": ")[^"]*')
}
cat << "EOF"
     .--.
    |o_o |	
    |:_/ |   ========= Google Dorker =========
   //   \ \  ====== Code by Florienzh4x ======
  (|     | ) ====== Thanks to Rinto AR =======
 /\'\_   _/`\
 \___)=(___/
EOF
echo ""
echo "Method: "
echo "1. Single Dork"
echo "2. Multi Dork"
read -p "Select: " pilihan;

if [[ -z $pilihan ]]; then
	printf "\nNo Input. Exit now\n"
	exit 1
fi

if [[ $pilihan -eq 1 ]]; then
	read -p "URL Only: (y/n)? " filter;
	read -p "Dork: " dorkmu;
	dorkna=''"$dorkmu"''
	eDork=$(echo $dorkmu | sed -f urlencode)
	nomer=1;
	for pages in {0..1000..10}; do
		printf "\n====== Grabbing from Page $nomer ======\n"
		Dorking $eDork $pages
		if [[ $Dorking == '' ]]; then
	    	printf "Not Links Found\n"
	    	break;
	    else
	    	if [[ $filter == 'y' || $filter == 'Y' ]]; then
	    		Url=$(echo $Dorking | grep -Po 'http.?://([[:alnum:]_.-]+?\.){1,5}[[:alpha:].]{2,10}/')
			    echo ''"$Url"''
			    echo "$Url" >> result.tmp
	    	else
			    echo ''"$Dorking"''
			    echo "$Dorking" >> result.tmp
			fi
	    fi
	    ((nomer++))
	done
elif [[ $pilihan -eq 2 ]]; then
	read -p "URL Only: (y/n)? " filter;
	read -p "Dork Files: " dork_file;
	if [[ ! -f $dork_file ]]; then
		echo "[404] File $dork_fileor not found. Check your dork file name."
		exit 1;		
	fi
	IFS=$'\r\n' GLOBIGNORE='*' command eval 'dorkna=($(cat $dork_file))'
	for (( i = 0; i <"${#dorkna[@]}"; i++ )); do
		dork_aing=$(echo ${dorkna[$i]} | sed -f urlencode)
		printf "\n[=] Searching Dork: ${dorkna[$i]}\n"
		nomer=1;
		for pages in {0..1000..10}; do
			printf "\n====== Grabbing from Page $nomer ======\n"
			mDorking $dork_aing $pages
			if [[ $Dorking == '' ]]; then
		    	printf "Not Links Found\n"
		    	break;
		    else
	    	if [[ $filter == 'y' || $filter == 'Y' ]]; then
	    		Url=$(echo $Dorking | grep -Po 'http.?://([[:alnum:]_.-]+?\.){1,5}[[:alpha:].]{2,10}/')
			    echo ''"$Url"''
			    echo "$Url" >> result.tmp
	    	else
			    echo ''"$Dorking"''
			    echo "$Dorking" >> result.tmp
			fi
		    fi
		    ((nomer++))
		done
	done
else
	printf "\nBad Input. Exit now\n"
fi
printf "\n\n[!] Filtering Result... \n"
time=$(date | sed 's/ /-/g')
cat result.tmp | sort -u | uniq >> Result-${time}.txt
printf "[+] Total : $(cat Result-${time}.txt | wc -l) Sites\n"
