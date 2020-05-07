<?php

function jhwh_tochileanpeso( $amount ) {
    return str_replace( ',', '.', $amount );
}
function jhwh_tochileanpeso2( $amount ) {
    return '$' . number_format( $amount, 0, ',', '.' );
}

$incremented_font_size            = 1;
$incremented_font_size_tableitems = 2;

# Logo
if ( file_exists( ROOTDIR.'/assets/img/logo.png' ) )
    $pdf->Image( ROOTDIR.'/assets/img/logo.png', 16, 27, 49 );
elseif ( file_exists( ROOTDIR.'/assets/img/logo.jpg' ) )
    $pdf->Image( ROOTDIR.'/assets/img/logo.jpg', 16, 27, 49 );
else 
    $pdf->Image( ROOTDIR.'/assets/img/placeholder.png', 16, 27, 75 );

# Company Details
$pdf->SetXY(15, 22);
$pdf->SetFont( $pdfFont,'', 13 + $incremented_font_size);
$pdf->Cell( 185, 6, trim( $companyaddress[0] ), 0, 1, 'R' );
$pdf->SetFont( $pdfFont, '', 9 + $incremented_font_size );
for ( $i = 1; $i <= ( ( count($companyaddress ) > 6 ) ? count( $companyaddress ) : 6 ); $i += 1 ) {
    $pdf->Cell( 185, 4, trim( $companyaddress[$i] ), 0, 1, 'R' );
}
$pdf->Ln(-1);

# Header Bar

$pdf->SetFont($pdfFont, 'B', 15 + $incremented_font_size);
$pdf->SetFillColor(239);
$pdf->Cell(0, 8, $_LANG['quotenumber'] . $quotenumber, 0, 1, 'L', '1');
$pdf->SetFont($pdfFont, '', 10 + $incremented_font_size);
$pdf->Cell(0, 6, $_LANG['quotesubject']     . ': ' . $subject, 0, 1, 'L', '1');
$pdf->Cell(0, 6, $_LANG['quotedatecreated'] . ': ' . $datecreated, 0, 1, 'L', '1');
$pdf->Cell(0, 6, $_LANG['quotevaliduntil']  . ': ' . $validuntil, 0, 1, 'L', '1');
$pdf->Ln(8);

$pdf->SetFont($pdfFont,'B',10 + $incremented_font_size);
$pdf->Cell(0,4,$_LANG['quoterecipient'] . ':',0,1);
$pdf->SetFont($pdfFont,'',9 + $incremented_font_size);
if ($clientsdetails["companyname"]) {
    $pdf->Cell(0,4,$clientsdetails["companyname"],0,1,'L');
    $pdf->Cell(0,4,$_LANG["invoicesattn"].": ".$clientsdetails["firstname"]." ".$clientsdetails["lastname"],0,1,'L');
} else {
    $pdf->Cell(0,4,$clientsdetails["firstname"]." ".$clientsdetails["lastname"],0,1,'L');
}
if ($clientsdetails["address1"]) {
    $pdf->Cell(0,4,$clientsdetails["address1"],0,1,'L');
}
if ($clientsdetails["address2"]) {
    $pdf->Cell(0,4,$clientsdetails["address2"],0,1,'L');
}
$jhwh_quotepdf_address_city_state_country = trim( $clientsdetails['city'] );
$jhwh_quotepdf_address_city_state_country .= empty( trim( $clientsdetails['state'] ) )   ? '' : ( empty( $jhwh_quotepdf_address_city_state_country ) ? '' : ', ' ) . $clientsdetails['state'];
$jhwh_quotepdf_address_city_state_country .= empty( trim( $clientsdetails['postcode'] ) )   ? '' : ( empty( $jhwh_quotepdf_address_city_state_country ) ? '' : ', ' ) . 'C.P. ' . $clientsdetails['postcode'];
$jhwh_quotepdf_address_city_state_country .= empty( trim( $clientsdetails['country'] ) )   ? '' : ( empty( $jhwh_quotepdf_address_city_state_country ) ? '' : ', ' ) . $clientsdetails['country'];

$pdf->Cell(0,4, $jhwh_quotepdf_address_city_state_country, 0,1,'L');
$pdf->Ln(10);

if ($proposal) {
    $pdf->SetFont($pdfFont,'',9 + $incremented_font_size);
    $pdf->MultiCell(170,5,$proposal);
    $pdf->Ln(10);
}

$pdf->SetDrawColor(200);
$pdf->SetFillColor(239);

$pdf->SetFont($pdfFont,'',8 + $incremented_font_size_tableitems);

$tblhtml = '<table width="100%" bgcolor="#ccc" cellspacing="1" cellpadding="2" border="0">
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;text-align:center;">
        <td width="5%">'.$_LANG['quoteqty'].'</td>
        <td width="45%">'.$_LANG['quotedesc'].'</td>
        <td width="15%">'.$_LANG['quoteunitprice'].'</td>
        <td width="15%">' . str_replace( 'Descuento', 'Desc.', $_LANG['quotediscount'] ) . '</td>
        <td width="20%">'.$_LANG['invoicesamount'].'</td>
    </tr>';
foreach ($lineitems AS $item) {
    $tblhtml .= '
    <tr bgcolor="#fff">
        <td align="center">'.$item['qty'].'</td>
        <td align="left">'.nl2br($item['description']).'<br /></td>
        <td align="center">' . jhwh_tochileanpeso2( $item['unitprice'] ) . '</td>
        <td align="center">' . $item['discount'] . '%' . '</td>
        <td align="center">' . jhwh_tochileanpeso( $item['total'] ) . '</td>
    </tr>';
}
$tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right" colspan="4">'.$_LANG['invoicessubtotal'].'</td>
        <td align="center">' . jhwh_tochileanpeso( $subtotal ) . '</td>
    </tr>';
if ($taxlevel1['rate']>0) $tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right" colspan="4">'.$taxlevel1['name'].' @ '.$taxlevel1['rate'].'%</td>
        <td align="center">' . jhwh_tochileanpeso( $tax1 ) . '</td>
    </tr>';
if ($taxlevel2['rate']>0) $tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right" colspan="4">'.$taxlevel2['name'].' @ '.$taxlevel2['rate'].'%</td>
        <td align="center">' . jhwh_tochileanpeso( $tax2 ) . '</td>
    </tr>';
$tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right" colspan="4">'.$_LANG['quotelinetotal'].'</td>
        <td align="center">' . jhwh_tochileanpeso( $total ) . '</td>
    </tr>
</table>';

$pdf->writeHTML($tblhtml, true, false, false, false, '');

if ($notes) {
    $pdf->Ln(6);
    $pdf->SetFont($pdfFont,'',8 + $incremented_font_size_tableitems);
    $pdf->MultiCell(170,5,$_LANG['invoicesnotes'].": $notes");
}
