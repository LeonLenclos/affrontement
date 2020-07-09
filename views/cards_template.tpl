<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
% include('nav_template.tpl')

<div class="editor">
% for card in cards:
<div class="card_container">

    % title = card['title']
    % primary_types = card['primary_types']
    % secondary_types = card['secondary_types']
    % card_rules = card['card_rules']
    % include('card_template.tpl')
    <div><a href="/modify/{{card['id']}}">modifier</a> - 
    <a href="/delete/{{card['id']}}">suprimer</a></div>
</div>
% end
</div>
</body>
</html>