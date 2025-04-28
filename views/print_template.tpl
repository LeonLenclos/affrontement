<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="/style.css">
    <link rel="stylesheet" type="text/css" href="/print.css">
</head>
<body>
% import storage

<div class="print">
 % for card in cards:
<div class="card_container">
    % title = card['title']
    % primary_types = card['primary_types']
    % secondary_types = card['secondary_types']
    % card_rules = card['card_rules']
    % include('card_template.tpl')
</div>
% end
</div>
</body>
</html>