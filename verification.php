<html>
<head>
<title>
Login
</title>
</body>
<?php

$username = $_POST["username"];
$password = $_POST["password"];


if (($username == sam)&&($password==sam)) {

 header('Location: dashboard.html');
}
else {
echo " <h2> WRONG PASSWORD OR USERNAME </h2>";
}

?>
</body>
</html>

