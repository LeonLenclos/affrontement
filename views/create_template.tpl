<!DOCTYPE html>
<html>
<head>
    <title>Créeeeeer une carte.....</title>
    <link rel="stylesheet" type="text/css" href="/style.css">
</head>

<body>
% include('nav_template.tpl')
<div class="editor">
<div class="card_container">
    % include('card_template.tpl')
</div>

<div class="form_container">
<h1>Creer une carte</h1>
    % include('card_form_template.tpl')
</div>
</div>
</body>
</html>