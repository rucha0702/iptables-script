# **iptables Management Script**

This script provides a user-friendly interface to manage `iptables` rules on a Linux system. It allows users to add rules, flush all rules, and flush rules from a particular chain within a specific table (Filter or NAT). The script also supports adding rules to the **Filter** and **NAT** tables with various chain options.

## **Features**
- **Add Rules**: Add rules to the **Filter** and **NAT** tables with customizable parameters such as protocol, source/destination IP, and ports.
- **Flush All Rules**: Flush all rules in the `iptables` configuration.
- **Flush Rules from a Specific Chain**: Allows flushing rules from a specific chain in both the **Filter** and **NAT** tables.
- **Interactive User Input**: Simple and interactive prompt for the user to provide input based on the required operations.

---

## **Prerequisites**
- **Linux system** with `iptables` installed.
- **sudo** privileges to modify firewall settings.
  
---

## **How to Use**

1. **Clone or Download the Script**
   - Download the script or clone it using `git`:

     ```bash
     git clone https://github.com/rucha0702/iptables-script.git
     ```

2. **Make the Script Executable**
   - After downloading the script, give it executable permissions:

     ```bash
     chmod +x iptables.sh
     ```

3. **Run the Script**
   - To execute the script, use the following command:

     ```bash
     sudo ./iptables.sh
     ```

   - The script will prompt you for a series of options to manage the `iptables` rules.

---

## **Options Available in the Script**

1. **Add Rule**  
   - This option allows you to add a rule to either the **Filter** or **NAT** table.
     - **Filter Table**: Works with chains like `INPUT`, `OUTPUT`, and `FORWARD`.
     - **NAT Table**: Works with chains like `PREROUTING`, `POSTROUTING`, and `OUTPUT`.
     - You can specify parameters such as:
       - Protocol (TCP, UDP, etc.)
       - Source IP address
       - Destination IP address
       - Source and Destination ports

2. **Flush All Rules**  
   - This option flushes all rules from all chains and tables in `iptables`, effectively clearing the entire firewall configuration.
   - **Confirmation**: The script will ask for user confirmation before flushing all rules.

3. **Flush Rules from a Specific Chain**  
   - This option allows you to flush rules from a specific chain in either the **Filter** or **NAT** table.
     - **Filter Table**: Choose chains `INPUT`, `OUTPUT`, or `FORWARD`.
     - **NAT Table**: Choose chains `PREROUTING`, `POSTROUTING`, or `OUTPUT`.

---

## **Example Usage**

1. **Add a Rule to Filter Table**

   - The user selects **Option 1** to add a rule, then selects **Filter** table and **INPUT** chain. Next, the user is prompted to input:
     - Protocol: `tcp`
     - Source IP: `192.168.1.1`
     - Destination Port: `80`

   The script will generate a rule similar to:
   ```bash
   sudo iptables -A INPUT -p tcp -s 192.168.1.1 --dport 80 -j ACCEPT
