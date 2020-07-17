<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
% import storage
% include('nav_template.tpl')


<div class="editor">
    
<!-- <div class="filters">
    
    <label for="title">Types principaux:</label>
    <select name="primary_types" size=5 multiple>
        % for type in storage.get_all_primary_types():

            % id = type['id']

            <option type=int value="{{id}}">{{type['name'].title()}}</option>
        % end
    </select>

    <label for="title">Types secondaires:</label>
    <select name="secondary_types" size=5 multiple>
        % for type in storage.get_all_secondary_types():

            % id = type['id']

            <option type=int value="{{id}}">{{type['name'].title()}}</option>
        % end
    </select>

    <script type="text/javascript">
        function update_hidden_cards() {


            document.querySelectorAll
        }
    </script>
</div>
 -->

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