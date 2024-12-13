echo "OPTIONS:
1. Add rule
2. Flush all rules"

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
		sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
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
