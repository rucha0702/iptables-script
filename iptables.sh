echo "OPTIONS:
1. Add rule
2. Flush all rules
"

read -p "Enter choice number: "  n

if [ $n -eq 1 ] 
then
echo "Choose table
1. Filter
2. NAT
";
read -p "Enter choice number: " table
	if [ $table -eq 1 ]
	then
	echo "Choose chain
	1. INPUT
	2. OUTPUT
	3. FORWARD
	"
	read -p "Enter choice number: " chain
		if [ $chain -eq 1 ]
		then
		read -p "Enter Protocol(press enter if not)" protocol
		read -p "Enter Destination Port(press enter if not)" dport
		read -p "Enter Source Port(press enter if not)" sport
		read -p "Enter Destination(press enter if not)" dst
		read -p "Enter Source(press enter if not)" src
		command="sudo iptables -A INPUT"
		count=0
                [[ -n $protocol ]] && command+=" -p $protocol" && count+=1
		[[ -n $dport ]] && command+=" --dport $dport" && count+=1
		[[ -n $sport ]] && command+=" --sport $sport" && count+=1
		[[ -n $dst ]] && command+=" -d $dst" && count+=1
		[[ -n $src ]] && command+=" -s $src" && count+=1
		echo "$protocol $dport $sport $dst $src"
                echo "command: $command"
		command+=" -j ACCEPT"
		[[ count -eq 0 ]] && echo "No parameters entered" || $command
		#sudo iptables -A INPUT [[ -z $protocol ]] && || -p $protocol --dport 80 -j ACCEPT
		elif [ $chain -eq 2 ]
		then
		sudo iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
		else
		echo "Wrong chain number"
		fi
	else
	echo "Wrong table number"
	fi
elif [ $n -eq 2 ]
then
echo "Flushing iptables"
sudo iptables -F
else
echo "Wrong choice"
fi
sudo iptables -L
