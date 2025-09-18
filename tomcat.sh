#!/bin/bash

# Download Tomcat 9.0.108
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.108/bin/apache-tomcat-9.0.108.tar.gz

# Extract Tomcat
tar -zxvf apache-tomcat-9.0.108.tar.gz

# Configure tomcat-users.xml properly
# First, backup the original file
cp apache-tomcat-9.0.108/conf/tomcat-users.xml apache-tomcat-9.0.108/conf/tomcat-users.xml.backup

# Use proper XML editing - replace the entire <tomcat-users> section
cat > apache-tomcat-9.0.108/conf/tomcat-users.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager-jmx"/>
  <role rolename="manager-status"/>
  <user username="tomcat" password="admin@123" roles="manager-gui,manager-script,manager-jmx,manager-status"/>
</tomcat-users>
EOF

# Configure manager context to allow remote access
# Backup the original context.xml
cp apache-tomcat-9.0.108/webapps/manager/META-INF/context.xml apache-tomcat-9.0.108/webapps/manager/META-INF/context.xml.backup

# Comment out the IP restriction instead of deleting lines
sed -i 's|<!-- <Valve className="org.apache.catalina.valves.RemoteAddrValve"|<!-- <Valve className="org.apache.catalina.valves.RemoteAddrValve"|' apache-tomcat-9.0.108/webapps/manager/META-INF/context.xml
sed -i 's|         allow="127\.\d+\.\d+\.\d+|         allow="127\.\d+\.\d+\.\d+|' apache-tomcat-9.0.108/webapps/manager/META-INF/context.xml
sed -i 's|         allow="::1" /> -->|         allow="::1" /> -->|' apache-tomcat-9.0.108/webapps/manager/META-INF/context.xml

# Alternatively, to allow all IPs (less secure but easier)
# Replace the entire Valve section with a comment or remove restrictions
sed -i 's|allow="127\.\\d\+\\.\\d\+\\.\\d\+|allow=".*"|' apache-tomcat-9.0.108/webapps/manager/META-INF/context.xml

# Make startup script executable
chmod +x apache-tomcat-9.0.108/bin/startup.sh
chmod +x apache-tomcat-9.0.108/bin/catalina.sh

# Start Tomcat
sh apache-tomcat-9.0.108/bin/startup.sh

echo "Tomcat 9.0.108 installed and started successfully!"
echo "Manager URL: http://$(hostname -I | awk '{print $1}'):8080/manager/html"
echo "Username: tomcat"
echo "Password: admin@123"





sudo mkdir -p /var/tmp_disk
sudo chmod 1777 /var/tmp_disk
sudo mount --bind /var/tmp_disk /tmp
echo '/var/tmp_disk /tmp none bind 0 0' | sudo tee -a /etc/fstab
sudo systemctl mask tmp.mount
df -h /tmp
