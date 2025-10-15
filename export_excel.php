<?php
session_start();
require_once 'config.php';

if (!isset($_SESSION['user_id'])) {
    header('Location: index.php');
    exit();
}

$query = "SELECT chek.Akt as Akt, zayavka.DateZ AS DateZ, model.NaimenModel AS ModelName, mark.NaimenMark AS MarkName, 
    GROUP_CONCAT(DISTINCT zapch.NaimenZap) AS UsedParts, SUM(zapch.CenaZap) AS TotalPartsCost, 
    GROUP_CONCAT(DISTINCT typeusl.NaimenUsl) AS UsedServices, SUM(typeusl.CenaUsl) AS TotalServicesCost, 
    SUM(zapch.CenaZap) + SUM(typeusl.CenaUsl) AS TotalRemSum 
    FROM bdkurs.chek AS chek 
    JOIN bdkurs.zayavka AS zayavka ON chek.Zayavka_idZ = zayavka.idZ 
    JOIN bdkurs.zapch AS zapch ON chek.Zapch_idZap = zapch.idZap 
    JOIN bdkurs.typeusl AS typeusl ON zapch.TypeUsl_idUsl = typeusl.idUsl 
    JOIN bdkurs.ts AS ts ON zayavka.Ts_idTs = ts.idTs 
    JOIN bdkurs.model AS model ON ts.Model_idModel = model.idModel 
    JOIN bdkurs.mark AS mark ON model.Mark_idMark = mark.idMark 
    GROUP BY Akt,zayavka.idZ, zayavka.DateZ, model.NaimenModel, mark.NaimenMark 
    ORDER BY Akt, zayavka.DateZ";

$stmt = $pdo->query($query);
$reports = $stmt->fetchAll(PDO::FETCH_ASSOC);

header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename=report.csv');

$output = fopen('php://output', 'w');

// Add BOM to support UTF-8 in Excel
fputs($output, chr(0xEF) . chr(0xBB) . chr(0xBF));

// Output the column headings
fputcsv($output, [
    'Акт', 
    'Дата', 
    'Модель', 
    'Марка', 
    'Использованные запчасти', 
    'Стоимость запчастей', 
    'Выполненные услуги', 
    'Стоимость услуг', 
    'Общая сумма'
]);

// Output the data
foreach ($reports as $row) {
    fputcsv($output, $row);
}

fclose($output);
exit();
?> 