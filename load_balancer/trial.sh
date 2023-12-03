#!/bin/bash

# Update the system
sudo apt-get update
sudo apt-get upgrade -y

# Install HAproxy
sudo apt-get install -y haproxy

# Configure HAproxy
cat > /etc/haproxy/haproxy.cfg <<EOL
global
    log /dev/log local0
    log /dev/log local1 notice
    daemon

defaults
    log global
    mode http
    option httplog
    option dontlognull
    retries 3
    timeout connect 5000
    timeout client 50000
    timeout server 50000

frontend http-in
    bind *:80
    default_backend webservers

backend webservers
    balance roundrobin
    server 5797-web-01 3.89.162.121:80 check
    server 5797-web-02 54.235.50.76:80 check
EOL

# Restart HAproxy
sudo service haproxy restart

# Configure init script
cat > /etc/init.d/haproxy <<EOL
#!/bin/sh

### BEGIN INIT INFO
# Provides:          haproxy
# Required-Start:    \$remote_fs \$syslog
# Required-Stop:     \$remote_fs \$syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/Stop HAProxy Load Balancer
### END INIT INFO

case "\$1" in
    start)
        /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -D
        ;;
    stop)
        kill \`cat /var/run/haproxy.pid\`
        ;;
    restart)
        kill \`cat /var/run/haproxy.pid\`
        /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -D
        ;;
    *)
        echo "Usage: \$0 {start|stop|restart}"
        exit 1
        ;;
esac

exit 0
EOL

# Make the init script executable
sudo chmod +x /etc/init.d/haproxy

# Register the init script
sudo update-rc.d haproxy defaults
