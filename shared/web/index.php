<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<body>
<div class="container">
    <h1>New Relic Agent configuration</h1>
    <p>Having issues? Check out <a target="_blank" href="https://github.com/J4zen/qnap-newrelic-agent">https://github.com/J4zen/qnap-newrelic-agent</a>
    </p>
    <hr/>

    <?php
    $config_path = "../NewRelicInfraAgent.conf";
    $pid_path = "../var/run/newrelic-infra/newrelic-infra.pid";
    $config = file($config_path);

    if (!$config) {
        die("Unable to parse configuration file. Check $config_path in " . getcwd());
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['license'])) {
        for ($i = 0; $i < count($config); $i++) {
            $config[$i] = rtrim($config[$i]);
            if (strpos($config[$i], "license_key") !== false) {
                $config[$i] = "license_key: " . $_POST['license'];
            }
        }
        file_put_contents($config_path, implode(PHP_EOL, $config), LOCK_EX);
        $message[] = "Saved license key to configuration and restarting New Relic Infrastructure Agent.";
        shell_exec("sudo ../NewRelicInfraAgent.sh restart");
        sleep(1);
    } else {
        if (isset($_GET['control']) && $_GET['control'] == 'restart') {
            shell_exec("sudo ../NewRelicInfraAgent.sh restart");
            $message[] = 'Sent Restart command to New Relic agent.';
            sleep(1);
        }
    }

    foreach ($message as $msg) {
        echo '<div class="alert alert-primary" role="alert">' . $msg . '</div>';
    }

    ?>

    <h2>Current configuration:</h2>
    <?
    foreach ($config as $line) {
        echo $line . "<br />";
    }
    ?>

    <hr/>
    <h2>Status:</h2>
    <?
    $status = file($pid_path);
    if (!$status) {
        echo "Not running.";
    } else {
        echo "Running as PID $status[0]";
    }
    ?>
    <hr/>

    <h2>Control:</h2>
        <a href="?control=restart" class="btn btn-primary">Restart</a>
    <hr/>
    <h2>Change license key</h2>
    <form action="index.php" method="post">
        <div class="form-group">
            <label for="license">New relic license key:</label><br/>
            <input name="license" type="text"><br/>
        </div>
        <button type="submit" class="btn btn-primary">Save license</button>
    </form>
</div>
</body>
</html>
