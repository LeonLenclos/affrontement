<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="/style.css">
    <!-- <link rel="stylesheet" type="text/css" href="/font.css"> -->
</head>
<body>
% include('nav_template.tpl')
<div class="editor">
<div class="card_container">
    % include('card_template.tpl')
</div>

<div class="form_container">
    <h1>Suprimer la carte</h1>

    <form action="#" method="post">
        <input type="submit" value="Suprimer">
    </form>
</div>
</div>
</body>
</html>