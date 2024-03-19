#!/bin/bash
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install tomcat tomcat-admin-webapps -y 
sudo su 
cd /var/lib/tomcat/webapps/
mkdir /var/lib/tomcat/webapps/myapps
chmod 777 /var/lib/tomcat/webapps/myapps/index.html
chmod 777 /var/lib/tomcat/webapps/myapps/script.js
cd /etc/tomcat/
mv tomcat-users.xml tomcat-users.xml_backup
rm -rf tomcat-users.xml
cd /home/ec2-user/
cp ec2-user /etc/tomcat/tomcat-users.xml
sudo chown root:tomcat /etc/tomcat/tomcat-user.xml
sudo systemctl restart tomcat.service
/bin/echo "<body>
  <div>
    <h1>Madhu Soodhan:</h1>
    <h2>The current date and time is:</h2>
    <p id="date-container"></p> <!-- This is where the date and time will be displayed -->
  </div>
<script src="script.js"></script> <!-- This is where the JavaScript code that modifies the date and time element is located -->
</body> ">> /var/lib/tomcat/webapps/myapps/index.html
/bin/echo "// Function to get the current date and time
function getCurrentDateAndTime() {
  const dateTime = new Date();
  return dateTime.toLocaleString();
}

// Target an HTML element to display the current date and time
const dateDisplay = document.getElementById("date-container");

// Set the innerHTML of the element to the current date and time returned by the function
dateDisplay.innerHTML = getCurrentDateAndTime();">> /var/lib/tomcat/webapps/myapps/script.js

#<tomcat-users>
#<role rolename="admin"/>  
#<role rolename="admin-gui"/>  
#<role rolename="admin-script"/>  
#<role rolename="manager"/>  
#<role rolename="manager-gui"/>  
#<role rolename="manager-script"/>  
#<role rolename="manager-jmx"/>  
#<role rolename="manager-status"/>  
#<user name="admin" password="adminadmin" roles="admin,manager,admin-gui,admin-script,manager-gui,manager-script,manager-jmx,manager-status" />  
#</tomcat-users>" >> /etc/tomcat/tomcat-users.xml
