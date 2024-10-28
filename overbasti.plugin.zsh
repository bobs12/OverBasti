#!/bin/bash


HOSTS_FILE="hosts_list.txt"


basti_connect() {
    local host_name=$1


    local host_entry=$(grep "^$host_name:" "$HOSTS_FILE")

    if [ -n "$host_entry" ]; then
        local user=$(echo "$host_entry" | cut -d':' -f2)
        local jumphost=$(echo "$host_entry" | cut -d':' -f3)
        local destination=$(echo "$host_entry" | cut -d':' -f4)


        ssh -J "$user@$jumphost" "$user@$destination"
    else
        echo "Host '$host_name' not found."
    fi
}


basti_save() {

    echo -n "Write user name: "
    read user_input
    local user="$user_input"


    echo -n "Write ip jumphost ip: "
    read jumphost_input
    local jumphost="$jumphost_input"


    echo -n "Write endpoint ip: "
    read destination_input
    local destination="$destination_input"


    echo -n "Write host name: "
    read host_name_input
    local host_name="$host_name_input"


    echo "$host_name:$user:$jumphost:$destination" >> "$HOSTS_FILE"
    echo "Host '$host_name' saved."
}

basti_rm() {
    read -p "Write host name for remove : " host_name
    if grep -q "^$host_name:" "$HOST_FILE"; then
        grep -v "^$host_name:" "$HOST_FILE" > temp_file && mv temp_file "$HOST_FILE"
        echo "Host '$host_name' removed "
    else
        echo "Host '$host_name' not found."
    fi
}


basti_list() {
    if [[ -f "$HOSTS_FILE" ]]; then
        echo "List saved hosts:"
        cat "$HOSTS_FILE"
    else
        echo "File $HOSTS_FILE not found of file is empty."
    fi
}
basti_help() {

    echo -e "| |_| |_| |\n \       /\n  |     |\n  |     |\n  |     |\n /       \ \\n|_________|"
    echo "Commands:"
    echo "basti_save                      # Save and named conection for quick access" 
    echo "basti_connect <host name>       # Connect with savet host, write saved hostname"
    echo "basti_list                      # List saved hostname" 
} 
