<?php
  $correctCode = "";
  if(isset($_GET["account"], $_GET["amount"], $_GET["code"])) {
    $account = $_GET["account"]; // $account is the account the money will be transferred to
    $amount = $_GET["amount"]; // $amount is the amount that is to be transferred
    $code = $_GET["code"]; //$code is the code that is needed to add money to the account (entered at the bank terminal)
  } else {
    echo "error";
    die();
  }
  $db = new SQLite3('money.db');
  $statement = $db->prepare('SELECT balance FROM accounts WHERE UUID=:account');
  $statement->bindValue(':account', $account);
  $oldBalance = $statement->execute();
  $oldBalance = $oldBalance->fetchArray(SQLITE3_ASSOC);
  
  $statement1 = $db->prepare('SELECT pin FROM accounts WHERE UUID=:account');
  $statement1->bindValue(':account', $account);
  $cardPin = $statement1->execute();
  $cardPin = $cardPin->fetchArray(SQLITE3_ASSOC);
  
  if($code != $correctCode) {
    echo "pin";
  } else {
    $statement = $db->prepare('UPDATE accounts SET balance=:newAmount WHERE UUID=:account');
    $statement->bindValue(':newAmount', $oldBalance["balance"] + $amount);
    $statement->bindValue(':account', $account);
    $statement->execute();
    echo "confirm";
  }
  
  $db->close();
  
?>