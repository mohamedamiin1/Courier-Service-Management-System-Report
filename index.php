<?php
// Database connection parameters
$username = 'system'; // Replace with your Oracle username
$password = '1234'; // Replace with your Oracle password
$host = 'Amiin'; // Replace with your Oracle host (e.g., localhost)
$port = '1521'; // Replace with your Oracle port (e.g., 1521)
$service_name = 'ORCL'; // Replace with your Oracle service name

// Database connection string
$dsn = "oci:dbname=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$host)(PORT=$port))(CONNECT_DATA=(SERVICE_NAME=$service_name)))";

// Attempt to establish a connection to the Oracle database
try {
    $connection = new PDO($dsn, $username, $password);
    $connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    exit; // Terminate script execution if connection fails
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CSMS - Home</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Custom CSS -->
    <style>
        /* Custom CSS */
        body {
            background-color: #f8f9fa;
            color: #333;
            font-family: Arial, sans-serif;
        }

        .navbar {
            border-radius: 0;
        }

        .jumbotron {
            background-color: #343a40;
            color: #fff;
        }

        .jumbotron h1,
        .jumbotron p {
            text-align: center;
        }

        .navbar-brand {
            font-weight: bold;
        }

        .nav-item {
            margin-right: 10px;
        }

        .nav-link {
            color: #fff;
            position: relative;
        }

        .nav-link:hover {
            color: #ccc;
        }

        .nav-link:hover .user-email {
            display: block;
        }

        .user-email {
            display: none;
            position: absolute;
            background-color: #343a40;
            padding: 5px;
            border-radius: 5px;
            top: 100%;
            left: 0;
            white-space: nowrap;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">CSMS</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="customer/register.php">Customer Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="branch/add_new.php">Branch</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="branch_staff/add_staff.php">Branch Staff</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="delivery/schedule.php">Delivery</a>
                    </li>
                </ul>
                <ul class="navbar-nav ml-auto">
                    <?php if(isset($_COOKIE['user'])): ?>
                        <?php $userEmail = $_COOKIE['user']; ?>
                        <li class="nav-item">
                            <a class="nav-link" href="#">Profile
                                <span class="user-email"><?php echo htmlspecialchars($userEmail); ?></span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">Cart
                                <span class="user-email"><?php echo htmlspecialchars($userEmail); ?></span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="login/logout.php">Logout
                                <span class="user-email"><?php echo htmlspecialchars($userEmail); ?></span>
                            </a>
                        </li>
                    <?php else: ?>
                        <li class="nav-item">
                            <a class="nav-link" href="login/loginpage.php">Login</a>
                        </li>
                    <?php endif; ?>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="jumbotron">
            <h1 class="display-4">Courier Service Management System (CSMS)</h1>
            <p class="lead">This is the landing page for my CSMS.</p>
            <hr class="my-4">
            <p>Developed by Mohamed Abdiwahaab Mohamed.</p>
        </div>
    </div>

    <footer class="text-center mt-4">
        <p>&copy; 2024 Mohamed Aiin. All rights reserved. Courier Management System</p>
    </footer>

    <!-- Bootstrap JS and dependencies (Popper.js and jQuery) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
