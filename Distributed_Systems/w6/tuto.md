# Tutorial 6: Web hosting in linux

![about to create a new vm](assets/about%20to%20create%20a%20new%20vm.png)


![configuring_resourcess_1](assets/configuring_resourcess_1.png)

![configuring_resourcess_2](assets/configuring_resoureces_2.png)


![review_create](assets/review_create.png)

![reviwe_create_2](assets/reviwe_create_2.png)

![initializingdeployment](assets/initializingdeployment.png)


![deploymentinprogress](assets/deploymentinprogress.png)

![deploymentComplete](assets/deploymentComplete.png)

![description](assets/description.png)

## My Public IP: 20.169.163.62


![loginwithssh](assets/loginwithssh.png)

![installwebmin](assets/installwebmin.png)

![addingwebminrepotosources](assets/addingwebminrepotosources.png)

![morewebminstuff](assets/morewebminstuff.png)

![updatingwithwebmin](assets/updatingwithwebmin.png)

![installingWebmin](assets/installingWebmin.png)

![moreinstallingwebmin](assets/moreinstallingwebmin.png)

![installedwebmin](assets/installedwebmin.png)

![inboundportrule](assets/inboundportrule.png)

![webminthing](assets/webminthing.png)

![allowed](assets/allowed.png)

![webminlogin](assets/webminlogin.png)

![loggedinwebmin](assets/loggedinwebmin.png)

![installingapache](assets/installingapache.png)

![apacheInstalled](assets/apacheInstalled.png)

![apachewebmin](assets/apachewebmin.png)

![installMYSQL](assets/installMYSQL.png)

![mysqlcli](assets/mysqlcli.png)

![installphp](assets/installphp.png)

![phpversion](assets/phpversion.png)

![htmlfolder](assets/htmlfolder.png)

![hello](assets/hello.png)

![changepermissions](assets/changepermissions.png)

![workingwebpage](assets/workingwebpage.png)

![infophp](assets/infophp.png)

![phpinfo](assets/phpinfo.png)

![newdb](assets/newdb.png)

![sqlquery](assets/sqlquery.png)

![result](assets/result.png)
![results](assets/results.png)

![newphpuser](assets/newphpuser.png)
![newdbpermission](assets/newdbpermission.png)

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

![mysqlnewuser](assets/newuserphpcli.png)

![allowingpermissions](assets/allowingpermissions.png)

![final](assets/final.png)
