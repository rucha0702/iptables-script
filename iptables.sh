echo "OPTIONS:
1. Add rule
2. Flush all rules
3. Flush all rules from a chain of a table"

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
    echo "Choose chain:
    1. INPUT
    2. OUTPUT
    3. FORWARD
    "
    read -p "Enter choice number: " chain

    if [ $chain -eq 1 ]
    then
        # INPUT chain logic
        read -p "Enter Protocol (ex: tcp, udp, press enter if not): " protocol
        read -p "Enter Destination Port (ex: 9090, press enter if not): " dport
        read -p "Enter Source Port (ex: 8080, press enter if not): " sport
        read -p "Enter Destination IP (ex: 192.168.10.0, press enter if not): " dst
        read -p "Enter Source IP (ex: 192.168.20.0, press enter if not): " src
        command="sudo iptables -A INPUT"
        count=0
        [[ -n $protocol ]] && command+=" -p $protocol" && ((count+=1))
        [[ -n $dport ]] && command+=" --dport $dport" && ((count+=1))
        [[ -n $sport ]] && command+=" --sport $sport" && ((count+=1))
        [[ -n $dst ]] && command+=" -d $dst" && ((count+=1))
        [[ -n $src ]] && command+=" -s $src" && ((count+=1))
        echo "Command: $command"
        command+=" -j ACCEPT"
        if [ $count -eq 0 ]; then
            echo "No parameters entered"
        else
            $command
        fi

    elif [ $chain -eq 2 ]
    then
        # OUTPUT chain logic
        read -p "Enter Protocol (ex: tcp, udp, press enter if not): " protocol
        read -p "Enter Destination Port (ex: 9090, press enter if not): " dport
        read -p "Enter Source Port (ex: 8080, press enter if not): " sport
        read -p "Enter Destination IP (ex: 192.168.10.0, press enter if not): " dst
        read -p "Enter Source IP (ex: 192.168.20.0, press enter if not): " src
        command="sudo iptables -A OUTPUT"
        count=0
        [[ -n $protocol ]] && command+=" -p $protocol" && ((count+=1))
        [[ -n $dport ]] && command+=" --dport $dport" && ((count+=1))
        [[ -n $sport ]] && command+=" --sport $sport" && ((count+=1))
        [[ -n $dst ]] && command+=" -d $dst" && ((count+=1))
        [[ -n $src ]] && command+=" -s $src" && ((count+=1))
        echo "Command: $command"
        command+=" -j ACCEPT"
        if [ $count -eq 0 ]; then
            echo "No parameters entered"
        else
            $command
        fi

    elif [ $chain -eq 3 ]
    then
        # FORWARD chain logic
        read -p "Enter Protocol (ex: tcp, udp, press enter if not): " protocol
        read -p "Enter Destination Port (ex: 9090, press enter if not): " dport
        read -p "Enter Source Port (ex: 8080, press enter if not): " sport
        read -p "Enter Destination IP (ex: 192.168.10.0, press enter if not): " dst
        read -p "Enter Source IP (ex: 192.168.20.0, press enter if not): " src
        command="sudo iptables -A FORWARD"
        count=0
        [[ -n $protocol ]] && command+=" -p $protocol" && ((count+=1))
        [[ -n $dport ]] && command+=" --dport $dport" && ((count+=1))
        [[ -n $sport ]] && command+=" --sport $sport" && ((count+=1))
        [[ -n $dst ]] && command+=" -d $dst" && ((count+=1))
        [[ -n $src ]] && command+=" -s $src" && ((count+=1))
        echo "Command: $command"
        command+=" -j ACCEPT"
        if [ $count -eq 0 ]; then
            echo "No parameters entered"
        else
            $command
        fi

    else
        echo "Wrong chain number"
    fi
elif [ $table -eq 2 ]; then
        echo "Choose chain for NAT table:
        1. PREROUTING (for DNAT)
        2. POSTROUTING (for SNAT, Masquerading)
        3. OUTPUT (for DNAT)
        "
        read -p "Enter choice number: " chain

        if [ $chain -eq 1 ]; then
            # PREROUTING chain for DNAT (destination NAT)
            read -p "Enter Protocol (ex: tcp, udp, press enter if not): " protocol
            read -p "Enter Destination Port (ex: 9090, press enter if not): " dport
            read -p "Enter Destination IP (ex: 192.168.10.0, press enter if not): " dst
            read -p "Enter Source IP (ex: 192.168.20.0, press enter if not): " src

            command="sudo iptables -t nat -A PREROUTING"
            count=0
            [[ -n $protocol ]] && command+=" -p $protocol" && ((count+=1))
            [[ -n $dport ]] && command+=" --dport $dport" && ((count+=1))
            [[ -n $dst ]] && command+=" -d $dst" && ((count+=1))
            [[ -n $src ]] && command+=" -s $src" && ((count+=1))
            read -p "Enter the IP to redirect traffic to (ex: 192.168.1.100): " redirect_ip

            command+=" -j DNAT --to-destination $redirect_ip"
            echo "Command: $command"
            if [ $count -eq 0 ]; then
                echo "No parameters entered"
            else
                $command
            fi

        elif [ $chain -eq 2 ]; then
            # POSTROUTING chain for SNAT or Masquerading
            read -p "Do you want to use Masquerading (y/n): " masquerade
            if [ "$masquerade" == "y" ] || [ "$masquerade" == "Y" ]; then
                echo "Using Masquerading..."
                sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
            else
                read -p "Enter Source IP (ex: 192.168.1.100): " src_ip
                read -p "Enter Destination Port (ex: 8080, press enter if not): " dport
                command="sudo iptables -t nat -A POSTROUTING -s $src_ip"
                count=0
                [[ -n $dport ]] && command+=" --dport $dport" && ((count+=1))
                echo "Command: $command"
                command+=" -j SNAT --to-source $src_ip"
                if [ $count -eq 0 ]; then
                    echo "No parameters entered"
                else
                    $command
                fi
            fi

        elif [ $chain -eq 3 ]; then
            # OUTPUT chain for DNAT (similar to PREROUTING for locally generated packets)
            read -p "Enter Protocol (ex: tcp, udp, press enter if not): " protocol
            read -p "Enter Destination Port (ex: 9090, press enter if not): " dport
            read -p "Enter Destination IP (ex: 192.168.10.0, press enter if not): " dst
            read -p "Enter Source IP (ex: 192.168.20.0, press enter if not): " src

            command="sudo iptables -t nat -A OUTPUT"
            count=0
            [[ -n $protocol ]] && command+=" -p $protocol" && ((count+=1))
            [[ -n $dport ]] && command+=" --dport $dport" && ((count+=1))
            [[ -n $dst ]] && command+=" -d $dst" && ((count+=1))
            [[ -n $src ]] && command+=" -s $src" && ((count+=1))
            read -p "Enter the IP to redirect traffic to (ex: 192.168.1.100): " redirect_ip

            command+=" -j DNAT --to-destination $redirect_ip"
            echo "Command: $command"
            if [ $count -eq 0 ]; then
                echo "No parameters entered"
            else
                $command
            fi

        else
            echo "Wrong chain number"
        fi
else
    echo "Wrong table number"
fi

elif [ $n -eq 2 ]
then
    echo "Are you sure you want to flush all iptables rules? (y/n)"
    read -p "Enter your choice: " confirmation

    if [ "$confirmation" == "y" ] || [ "$confirmation" == "Y" ]; then
        echo "Flushing iptables..."
        sudo iptables -F
    else
        echo "Operation cancelled. No rules were flushed."
    fi

elif [ $n -eq 3 ]; then
    echo "Choose table:
    1. Filter
    2. NAT
    "
    read -p "Enter choice number: " table

    if [ $table -eq 1 ]; then
        echo "Choose chain to flush:
        1. INPUT
        2. OUTPUT
        3. FORWARD
        "
        read -p "Enter choice number: " chain
        
        if [ $chain -eq 1 ]; then
            echo "Flushing INPUT chain..."
            sudo iptables -F INPUT
        elif [ $chain -eq 2 ]; then
            echo "Flushing OUTPUT chain..."
            sudo iptables -F OUTPUT
        elif [ $chain -eq 3 ]; then
            echo "Flushing FORWARD chain..."
            sudo iptables -F FORWARD
        else
            echo "Wrong chain number."
        fi

    elif [ $table -eq 2 ]; then
        echo "Choose chain to flush in NAT table:
        1. PREROUTING
        2. POSTROUTING
        3. OUTPUT
        "
        read -p "Enter choice number: " chain
        
        if [ $chain -eq 1 ]; then
            echo "Flushing PREROUTING chain in NAT table..."
            sudo iptables -t nat -F PREROUTING
        elif [ $chain -eq 2 ]; then
            echo "Flushing POSTROUTING chain in NAT table..."
            sudo iptables -t nat -F POSTROUTING
        elif [ $chain -eq 3 ]; then
            echo "Flushing OUTPUT chain in NAT table..."
            sudo iptables -t nat -F OUTPUT
        else
            echo "Wrong chain number."
        fi

    else
        echo "Wrong table number."
    fi

else
echo "Wrong choice"
fi

