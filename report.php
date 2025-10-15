<?php
session_start();
require_once 'config.php';

if (!isset($_SESSION['user_id'])) {
    header('Location: index.php');
    exit();
}

$startDate = isset($_GET['startDate']) ? $_GET['startDate'] : '';
$endDate = isset($_GET['endDate']) ? $_GET['endDate'] : '';

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
    JOIN bdkurs.mark AS mark ON model.Mark_idMark = mark.idMark ";

$whereClauses = [];
$queryParams = [];

if (!empty($startDate)) {
    $whereClauses[] = "zayavka.DateZ >= ?";
    $queryParams[] = $startDate;
}

if (!empty($endDate)) {
    $whereClauses[] = "zayavka.DateZ <= ?";
    $queryParams[] = $endDate;
}

if (!empty($whereClauses)) {
    $query .= " WHERE " . implode(" AND ", $whereClauses);
}

$query .= " GROUP BY Akt,zayavka.idZ, zayavka.DateZ, model.NaimenModel, mark.NaimenMark 
    ORDER BY Akt, zayavka.DateZ";

$stmt = $pdo->prepare($query);
$stmt->execute($queryParams);
$reports = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Отчет</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="style.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>
</head>
<body>
    <div class="container">
        <h1 class="text-center mb-4">Отчет по ремонтам</h1>
        <div class="nav mb-3 d-flex justify-content-between align-items-center">
            <div>
                <a href="admin.php" class="btn btn-primary me-2">Вернуться в админ панель</a>
                <a href="export_excel.php?startDate=<?php echo $startDate; ?>&endDate=<?php echo $endDate; ?>" class="btn btn-success me-2">Экспорт в Excel</a>
                <button onclick="generatePdf()" class="btn btn-info">Экспорт в PDF</button>
            </div>
            <form method="GET" class="d-flex">
                <div class="input-group me-2">
                    <span class="input-group-text">От</span>
                    <input type="date" class="form-control" name="startDate" value="<?php echo htmlspecialchars($startDate); ?>">
                </div>
                <div class="input-group me-2">
                    <span class="input-group-text">До</span>
                    <input type="date" class="form-control" name="endDate" value="<?php echo htmlspecialchars($endDate); ?>">
                </div>
                <button type="submit" class="btn btn-secondary">Показать</button>
            </form>
        </div>
        
        <div class="table-container" id="reportTable">
            <table class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>Акт</th>
                        <th>Дата</th>
                        <th>Модель</th>
                        <th>Марка</th>
                        <th>Использованные запчасти</th>
                        <th>Стоимость запчастей</th>
                        <th>Выполненные услуги</th>
                        <th>Стоимость услуг</th>
                        <th>Общая сумма</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($reports as $report): ?>
                        <tr>
                            <td><?php echo htmlspecialchars($report['Akt']); ?></td>
                            <td><?php echo htmlspecialchars($report['DateZ']); ?></td>
                            <td><?php echo htmlspecialchars($report['ModelName']); ?></td>
                            <td><?php echo htmlspecialchars($report['MarkName']); ?></td>
                            <td><?php echo htmlspecialchars($report['UsedParts']); ?></td>
                            <td><?php echo htmlspecialchars($report['TotalPartsCost']); ?></td>
                            <td><?php echo htmlspecialchars($report['UsedServices']); ?></td>
                            <td><?php echo htmlspecialchars($report['TotalServicesCost']); ?></td>
                            <td><?php echo htmlspecialchars($report['TotalRemSum']); ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function generatePdf() {
            const element = document.getElementById('reportTable');
            const opt = {
                margin:       10,
                filename:     'report.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 3 },
                jsPDF:        { unit: 'mm', format: 'a4', orientation: 'landscape' }
            };

            html2pdf().set(opt).from(element).outputPdf('datauristring').then(function(pdfAsString) {
                var win = window.open();
                win.document.write('<iframe width="100%" height="100%" src="' + pdfAsString + '" frameborder="0" allowfullscreen></iframe>');
                win.document.title = 'Отчет';
            });
        }
    </script>
</body>
</html> 