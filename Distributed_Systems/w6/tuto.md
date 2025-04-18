# Tutorial 6: Web hosting in linux

![about to create a new vm](assets/about%20to%20create%20a%20new%20vm.png)
Here, we are creating a new virtual machine
>

![configuring_resourcess_1](assets/configuring_resourcess_1.png)
Configuring resources for the said virtual machine.
>

![configuring_resourcess_2](assets/configuring_resoureces_2.png)
Configuring resources for the said virtual machine.
>

![review_create](assets/review_create.png)
Reviewing the creation of the virtual machine
>

![reviwe_create_2](assets/reviwe_create_2.png)
Reviewing the creation of the virtual machine
>

![initializingdeployment](assets/initializingdeployment.png)
Here, we are initializing the deployment
>


![deploymentinprogress](assets/deploymentinprogress.png)
Deployment in progress
>

![deploymentComplete](assets/deploymentComplete.png)
Deployment complete
>

![description](assets/description.png)
Description of my vm
==My Public IP: 20.169.163.62==

---

![loginwithssh](assets/loginwithssh.png)
Login with secure shell.
>

![installwebmin](assets/installwebmin.png)
using the wget to get the GPG public key frm webmin's servers.
>

![addingwebminrepotosources](assets/addingwebminrepotosources.png)
![morewebminstuff](assets/morewebminstuff.png)
Adding source to `sources.list` as webmin isnt available in the default standard library of ubuntu.
>
    
![updatingwithwebmin](assets/updatingwithwebmin.png)
![installingWebmin](assets/installingWebmin.png)
![moreinstallingwebmin](assets/moreinstallingwebmin.png)
![installedwebmin](assets/installedwebmin.png)
Installed webmin
>
![inboundportrule](assets/inboundportrule.png)
Setting up inbound port rules to allow all incoming request to hit :8080
>

![webminthing](assets/webminthing.png)
Adding Security Rules
>

![allowed](assets/allowed.png)
Finalized configuration for network settings
>

![webminlogin](assets/webminlogin.png)
Logging in to webmin
>

![loggedinwebmin](assets/loggedinwebmin.png)
logged in to webmin
>

![installingapache](assets/installingapache.png)
Installign apache 
>

![apacheInstalled](assets/apacheInstalled.png)
Installed apache
>

![apachewebmin](assets/apachewebmin.png)
Apache's default view
>

![installMYSQL](assets/installMYSQL.png)
Installing MySQL
>

![mysqlcli](assets/mysqlcli.png)
Verifying installation with mysqlcli
>

![installphp](assets/installphp.png)
Installing PHP
>

![phpversion](assets/phpversion.png)
Verification of installation
>

![htmlfolder](assets/htmlfolder.png)
the HTML folder where we place our webpages
>

![hello](assets/hello.png)
![changepermissions](assets/changepermissions.png)
![workingwebpage](assets/workingwebpage.png)
Putting a proof of concept webpage and making it work.
>

![infophp](assets/infophp.png)
Displaying php info via the webpage
>

![phpinfo](assets/phpinfo.png)
Displaying php info via the webpage
>

![newdb](assets/newdb.png)
Creating a new database
>

![sqlquery](assets/sqlquery.png)
Inserting mock records into the database
>

![result](assets/result.png)
![results](assets/results.png)
Results after completion of said operations
>

![newphpuser](assets/newphpuser.png)
Creating a new user
>
![newdbpermission](assets/newdbpermission.png)
changing permissions for said user

==The following code was used==

```php
~

<?php
$servername = "localhost";
$username = "phpuser";
$password = "Password123";
$dbname = "db2431342";

try {
    // Connect to MySQL
    $conn = mysqli_connect($servername, $username, $password, $dbname);
    
    if (!$conn) {
        throw new Exception("Connection failed: " . mysqli_connect_error());
    }

    // Query execution
    $sql = "SELECT * FROM Contacts";
    $result = mysqli_query($conn, $sql);

    if (!$result) {
        throw new Exception("Query execution failed: " . mysqli_error($conn));
    }

    // Fetch and display data
    while ($row = mysqli_fetch_array($result, MYSQLI_NUM)) {
        echo $row[0] . " " . $row[1] . " " . $row[2] . " " . $row[3] . "<br>";
    }

    // Close connection
    mysqli_close($conn);

} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
?>

```

![phpusernewgroup](assets/phpusernewgroup.png)
Changing the new user group
>

![mysqlnewuser](assets/newuserphpcli.png)
![allowingpermissions](assets/allowingpermissions.png)
Granting all permissions on the newly created database manually via the cli cause I forgot to do it earlier :< 
>

![final](assets/final.png)
Final working website

