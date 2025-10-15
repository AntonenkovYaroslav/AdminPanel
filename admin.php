<?php
session_start();
require_once 'config.php';

if (!isset($_SESSION['user_id'])) {
    header('Location: index.php');
    exit();
}

// Get user information
$stmt = $pdo->prepare("SELECT FamSotr, ImyaSotr FROM sotrudnik WHERE idSotr = ?");
$stmt->execute([$_SESSION['user_id']]);
$user = $stmt->fetch();

// Handle table operations
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['action'])) {
        $table = $_POST['table'];
        $action = $_POST['action'];
        $primary_key_column = $_POST['primary_key_column']; // Get primary key from hidden input

        switch ($action) {
            case 'add':
                $columns = implode(', ', array_keys($_POST['data']));
                $values = implode(', ', array_fill(0, count($_POST['data']), '?'));
                $stmt = $pdo->prepare("INSERT INTO $table ($columns) VALUES ($values)");
                $stmt->execute(array_values($_POST['data']));
                break;
                
            case 'edit':
                $set = implode(' = ?, ', array_keys($_POST['data'])) . ' = ?';
                $stmt = $pdo->prepare("UPDATE $table SET $set WHERE {$primary_key_column} = ?"); // Use dynamic primary key
                $values = array_values($_POST['data']);
                $values[] = $_POST['id']; // This 'id' is actually the value of the primary key
                $stmt->execute($values);
                break;
                
            case 'delete':
                $stmt = $pdo->prepare("DELETE FROM $table WHERE {$primary_key_column} = ?"); // Use dynamic primary key
                $stmt->execute([$_POST['id']]);
                break;
        }
    }
}

// Get table data
$tables = ['client', 'mark', 'model', 'sotrudnik', 'status', 'ts', 'typerab', 'typeusl', 'zapch', 'zayavka', 'chek'];
// Карта внешних ключей: поле => [таблица, поле id, поле наименования]
$foreign_keys = [
    'Mark_idMark' => ['mark', 'idMark', 'NaimenMark'],
    'Model_idModel' => ['model', 'idModel', 'NaimenModel'],
    'idStat' => ['status', 'idStat', 'NaimenStat'],
    'TypeRab_idRab' => ['typerab', 'idRab', 'NaimenRab'],
    'TypeUsl_idUsl' => ['typeusl', 'idUsl', 'NaimenUsl'],
    'Client_idClient' => ['client', 'idClient', "CONCAT(FamCl, ' ', ImyaCl) AS Name"],
    'Sotrudnik_idSotrudnik' => ['sotrudnik', 'idSotr', "CONCAT(FamSotr, ' ', ImyaSotr) AS Name"],
    'Ts_idTs' => ['ts', 'idTs', 'GosNum'],
    'Zapch_idZap' => ['zapch', 'idZap', 'NaimenZap'],
    'Zayavka_idZ' => ['zayavka', 'idZ', 'idZ'],
];

$current_table = isset($_GET['table']) ? $_GET['table'] : null;
$foreign_options = [];
if ($current_table && in_array($current_table, $tables)) {
    $stmt = $pdo->query("DESCRIBE $current_table");
    $columns_info = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $columns = [];
    $primary_key_column = '';

    foreach ($columns_info as $col_info) {
        $columns[] = $col_info['Field'];
        if ($col_info['Key'] === 'PRI') {
            $primary_key_column = $col_info['Field'];
        }
        // Если поле внешний ключ — подгружаем опции
        if (isset($foreign_keys[$col_info['Field']])) {
            $fk = $foreign_keys[$col_info['Field']];
            $table = $fk[0];
            $id = $fk[1];
            $name = $fk[2];
            $query = ($name === 'idZ') ? "SELECT $id, $name FROM $table" : "SELECT $id, $name FROM $table";
            $foreign_options[$col_info['Field']] = $pdo->query($query)->fetchAll(PDO::FETCH_ASSOC);
        }
    }

    $stmt = $pdo->query("SELECT * FROM $current_table");
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Админ панель</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="style.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h1 class="text-center mb-4">Админ панель</h1>
        <div class="nav mb-3 d-flex justify-content-between align-items-center">
            <div>
                <?php foreach ($tables as $table): ?>
                    <a href="?table=<?php echo $table; ?>" class="btn btn-primary btn-sm"><?php echo ucfirst($table); ?></a>
                <?php endforeach; ?>
            </div>
            <div>
                <a href="report.php" class="btn btn-success btn-sm">Отчет</a>
                <a href="logout.php" class="btn btn-danger btn-sm">Выход</a>
            </div>
        </div>

        <?php if (!$current_table): ?>
            <div class="welcome-message">
                <h2>Добро пожаловать, <?php echo $user['FamSotr'] . ' ' . $user['ImyaSotr']; ?>!</h2>
                <p>Выберите таблицу для работы из меню выше.</p>
            </div>
        <?php elseif (isset($data)): ?>
            <h2 class="mb-4"><?php echo ucfirst($current_table); ?></h2>
            <button onclick="showAddForm()" class="btn btn-success mb-3">Добавить запись</button>
            
            <div id="addEditFormContainer"></div>

            <div class="table-responsive">
                <table class="table table-striped table-bordered">
                    <thead class="table-dark">
                        <tr>
                            <?php foreach ($columns as $column): ?>
                                <th><?php echo $column; ?></th>
                            <?php endforeach; ?>
                            <th>Действия</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($data as $row): ?>
                            <tr>
                                <?php foreach ($columns as $column): ?>
                                    <td><?php echo htmlspecialchars($row[$column]); ?></td>
                                <?php endforeach; ?>
                                <td>
                                    <form method="POST" style="display: inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="table" value="<?php echo $current_table; ?>">
                                        <input type="hidden" name="primary_key_column" value="<?php echo $primary_key_column; ?>">
                                        <input type="hidden" name="id" value="<?php echo $row[$primary_key_column]; ?>">
                                        <button type="submit" class="btn btn-danger btn-sm">Удалить</button>
                                    </form>
                                    <button onclick="editRow(<?php echo htmlspecialchars(json_encode($row)); ?>, '<?php echo $primary_key_column; ?>')" class="btn btn-warning btn-sm">Редактировать</button>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showAddForm() {
            document.getElementById('addEditFormContainer').innerHTML = '';
            const columns = <?php echo json_encode($columns); ?>;
            const primaryKeyColumn = '<?php echo $primary_key_column; ?>';
            const foreignOptions = <?php echo json_encode($foreign_options); ?>;
            let formHtml = '<div class="form-container mb-3"><form method="POST"><input type="hidden" name="action" value="add"><input type="hidden" name="table" value="<?php echo $current_table; ?>"><input type="hidden" name="primary_key_column" value="' + primaryKeyColumn + '">';
            columns.forEach(column => {
                if (foreignOptions[column]) {
                    formHtml += `<div class=\"mb-2\"><label class=\"form-label visually-hidden\">${column}</label><select class=\"form-select form-select-sm\" name=\"data[${column}]\" required>`;
                    foreignOptions[column].forEach(opt => {
                        const keys = Object.keys(opt);
                        formHtml += `<option value=\"${opt[keys[0]]}\">${opt[keys[1]]}</option>`;
                    });
                    formHtml += '</select></div>';
                } else {
                    formHtml += `<div class=\"mb-2\"><label class=\"form-label visually-hidden\">${column}</label><input type=\"text\" class=\"form-control form-control-sm\" name=\"data[${column}]\" placeholder=\"${column}\" required></div>`;
                }
            });
            formHtml += '<button type="submit" class="btn btn-success btn-sm me-2">Добавить</button><button type="button" class="btn btn-secondary btn-sm" onclick="hideForm()">Отмена</button></form></div>';
            document.getElementById('addEditFormContainer').innerHTML = formHtml;
        }

        function editRow(row, primaryKeyColumn) {
            document.getElementById('addEditFormContainer').innerHTML = '';
            const columns = <?php echo json_encode($columns); ?>;
            const foreignOptions = <?php echo json_encode($foreign_options); ?>;
            let formHtml = '<div class="form-container mb-3"><form method="POST"><input type="hidden" name="action" value="edit"><input type="hidden" name="table" value="<?php echo $current_table; ?>"><input type="hidden" name="primary_key_column" value="' + primaryKeyColumn + '"><input type="hidden" name="id" value="' + row[primaryKeyColumn] + '">';
            columns.forEach(column => {
                if (column !== primaryKeyColumn) {
                    if (foreignOptions[column]) {
                        formHtml += `<div class=\"mb-2\"><label class=\"form-label visually-hidden\">${column}</label><select class=\"form-select form-select-sm\" name=\"data[${column}]\" required>`;
                        foreignOptions[column].forEach(opt => {
                            const keys = Object.keys(opt);
                            const selected = (row[column] == opt[keys[0]]) ? 'selected' : '';
                            formHtml += `<option value=\"${opt[keys[0]]}\" ${selected}>${opt[keys[1]]}</option>`;
                        });
                        formHtml += '</select></div>';
                    } else {
                        formHtml += `<div class=\"mb-2\"><label class=\"form-label visually-hidden\">${column}</label><input type=\"text\" class=\"form-control form-control-sm\" name=\"data[${column}]\" value=\"${row[column]}\" placeholder=\"${column}\" required></div>`;
                    }
                }
            });
            formHtml += '<button type="submit" class="btn btn-warning btn-sm me-2">Сохранить</button><button type="button" class="btn btn-secondary btn-sm" onclick="hideForm()">Отмена</button></form></div>';
            document.getElementById('addEditFormContainer').innerHTML = formHtml;
        }

        function hideForm() {
            document.getElementById('addEditFormContainer').innerHTML = '';
        }
    </script>
</body>
</html> 