<style>
:root {
    --page-width: 750px;
    --margin: 0px;
    --accent: #ff0000;
    --paper: #fff;
    --font-sans: Arial, Helvetica, sans-serif;
}

html,
body {
    background: #fff;
    padding: 0;
    margin: 0;
    font-family: var(--font-sans);
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

.page {
    width: var(--page-width);
    min-height: auto;
    margin: 10px auto;
    background: var(--paper);
    padding: var(--margin);
    box-sizing: border-box;
}
</style>
<div class="page">
    <!-- Header -->
    <img src="https://raw.githubusercontent.com/TamilSelvanRaja/mummycabs/main/assets/banner.png" alt="Company Logo"
        style="width:100%;height:150px;object-fit:contain;" />

    <!-- Company Info -->
    <div style="margin-top:10px; text-align: center;">
        <h2 style="color: #ff0000;margin: 5px 0;font-size: 28px;">MUMMY CABS</h2>
        <p style="color: #ff0000;font-size: 14px;font-weight: bold; margin: 2px 0;">
            TOURIST LUXURY VEHICLE SWIFT, ERTIGA, INNOVA & CAR OPERATORS (24 HOURS SERVICE)
        </p>
        <p style="color: #666; font-size: 14px;margin: 2px 0;">No. 91, (Old #36), Anna Street, (Near Kalakshetra
            Dance School Main Gate),</p>
        <p style="color: #666;font-size: 14px;margin: 2px 0;">Thiruvanmiyur, Chennai - 600 041. Mail:
            mummy_cabs@yahoo.com</p>
    </div>

    <!-- Invoice Meta -->
    <table style="width:100%;margin-top:10px">
        <tr>
            <td style="text-align:left;">
                <table>
                    <tr>
                        <td style="text-align:left;"><strong style="color: #666;font-size: 14px;">Customer : </strong>
                        </td>
                        <td><strong style="color: #a80f0f;font-size: 14px;"><?= htmlspecialchars($name) ?></strong></td>
                    </tr>
                </table>
            </td>
            <td style="text-align:right;"><strong style="color: #666;font-size: 14px;">Date :
                    <?= htmlspecialchars($date) ?></strong>
            </td>
        </tr>

    </table>



    <!-- Ledget Info -->
    <table style="width:100%; border-collapse:collapse; min-width:750px;margin-top:15px;">
        <thead>
            <tr>
                <th
                    style="width:20px; position:sticky; top:0;text-align:center; padding:12px 14px; font-weight:600; font-size:13px;border:1px solid #000;">
                    No</th>
                <th
                    style="width:60px; position:sticky; top:0;text-align:center; padding:12px 14px; font-weight:600; font-size:13px;border:1px solid #000">
                    Date</th>
                <th
                    style="width:85px; position:sticky; top:0;text-align:center; padding:12px 14px; font-weight:600; font-size:13px;border:1px solid #000">
                    Vehicle No</th>
                <th
                    style="position:sticky; top:0;text-align:center; padding:12px 14px; font-weight:600; font-size:13px;border:1px solid #000">
                    Descriptions</th>
                <th
                    style="width:120px; position:sticky;top:0;text-align:center;padding:12px 14px; font-weight:600; font-size:13px;border:1px solid #000">
                    Balance (₹)</th>
            </tr>
        </thead>
        <tbody>

            <?php foreach ($resdata as $index => $row): ?>

            <tr style="background:#ffffff;">
                <td style="text-align: center; border:1px solid #000;font-size: 12px;"><?= $index+1 ?></td>
                <td style="text-align: center;padding:6px 6px; border:1px solid #000;font-size: 12px;">
                    <?= htmlspecialchars($row["pickup_time"]) ?></td>
                <td style="text-align: center; padding:6px 6px; border:1px solid #000;font-size: 12px;">
                    <?= htmlspecialchars($row["vehicle_no"]) ?></td>
                <td style="padding:6px 6px; border:1px solid #000;font-size: 12px;">
                    <table style="width:100%;">
                        <tr>
                            <td> <strong
                                    style="color: #a80f0f;font-size: 14px;"><?= htmlspecialchars($row["pickup_place"]) ?>
                            </td>
                            <td> <strong
                                    style="color: #a80f0f;font-size: 14px;"><?= htmlspecialchars($row["drop_place"]) ?>
                            </td>
                        </tr>
                        <tr>
                            <td>Total Km</td>
                            <td>: <?= htmlspecialchars($row["km"]) ?></td>
                        </tr>
                        <tr>
                            <td>Extra KM</td>
                            <td>: <?= htmlspecialchars($row["extra_km"]) ?></td>
                        </tr>
                        <tr>
                            <td>Extra KM Amount</td>
                            <td>: <?= htmlspecialchars($row["extra_km_amount"]) ?></td>
                        </tr>
                        <tr>
                            <td>Driver Salary</td>
                            <td>: <?= htmlspecialchars($row["driver_salary"]) ?></td>
                        </tr>
                        <tr>
                            <td>Toll Gate</td>
                            <td>: <?= htmlspecialchars($row["toll_amt"]) ?></td>
                        </tr>
                        <tr>
                            <td>Parking</td>
                            <td>: <?= htmlspecialchars($row["parking"]) ?></td>
                        </tr>
                        <tr>
                            <td>Others</td>
                            <td>: <?= htmlspecialchars($row["other_amount"]) ?></td>
                        </tr>
                        <tr>
                            <td>Advance</td>
                            <td>: <?= htmlspecialchars($row["advance_amt"]) ?></td>
                        </tr>
                    </table>
                </td>
                <td style="padding:6px 6px; border:1px solid #000;text-align:right;font-size: 12px;">
                    <strong style="color: #a80f0f;font-size: 14px;"><?= htmlspecialchars($row["balance_amount"]) ?>
                </td>
            </tr>
            <?php endforeach; ?>


            <tr style="font-weight:700;">
                <td colspan="4" style="text-align:right; padding:12px 16px; border:1px solid #000;">
                    Totals</td>
                <td style="padding:12px 14px; border:1px solid #000; text-align:right;">
                    <strong style="color: #ff0000;font-size: 14px;"><?= htmlspecialchars($total_amt) ?>
                </td>
            </tr>
        </tbody>
    </table>

    <!-- Footer -->
    <div style="text-align: center;">
        <img src="https://raw.githubusercontent.com/TamilSelvanRaja/mummycabs/main/assets/border.png" alt="Company Logo"
            style="margin-top: 20px;text-align: center; width:auto;height:40px;object-fit:contain;" />
    </div>
    <div style="text-align: center;">
        <p style="font-size: 14px; font-weight: bold; color: #0400d5;">Software Developed & Designed by</p>
        <table style="width:100%;margin:5px auto;">
            <tr>
                <td style="text-align:left;"><Strong style="color: #a80f0f;font-size: 14px;">Tamilselvan
                        Raja</Strong>
                </td>
                <td style="text-align:right;"><Strong style="color: #ff0000;font-size: 14px;">(7010133599,
                        8270706750)</Strong>
                <td style="text-align:right;"><Strong
                        style="color: #a80f0f;font-size: 14px;">tamilselvanraja.official@gmail.com</Strong>
                </td>
            </tr>
        </table>
    </div>
</div>