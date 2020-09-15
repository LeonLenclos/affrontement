<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
% import storage
% include('nav_template.tpl')

<div>
    <label for="cards">Selection:</label>
    <input id="cards-list" name="cards">
    <label>Ne montrer que la selection:</label>
    <input id="filter-selection" type="checkbox">
</div>

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
<div class="card_container" data-card-id="{{card['id']}}">

    % title = card['title']
    % primary_types = card['primary_types']
    % secondary_types = card['secondary_types']
    % card_rules = card['card_rules']
    % include('card_template.tpl')
    <div>
        <a href="/modify/{{card['id']}}">modifier</a> - 
        <a href="/delete/{{card['id']}}">suprimer</a>
        <small><input class="card-selection" type="checkbox" value="{{card['id']}}">{{card['id']}}</small>

    </div>
</div>
% end
</div>




<script>
    let filterSelection = document.querySelector('#filter-selection');
    let checkboxes = document.querySelectorAll('.card-selection');
    let list = document.querySelector('#cards-list')

    updateListFromCheckboxes = (e) => {
        let listValue= ''
        for (var i = 0; i < checkboxes.length; i++) {
            if(checkboxes[i].checked){
                listValue+=checkboxes[i].value + ',';
            }
        }
        list.value = listValue;


    }

    updateCheckboxesFromList = (e) => {
        for (var i = 0; i < checkboxes.length; i++) {
            checkboxes[i].checked = false;
        }

        let cards = list.value.split(',')
        for (var i = 0; i < cards.length; i++) {
            let id =Number(cards[i])
            for (var j = 0; j < checkboxes.length; j++) {
                if(checkboxes[j].value == id){
                    checkboxes[j].checked = true;
                }
            }
        }
    }
    
    updateFilter = (e) => {
        let containers = document.querySelectorAll('.card_container')
        let cards_selected = list.value.split(',').map(Number)

        if(filterSelection.checked){
            for (var i = 0; i < containers.length; i++) {
                if(cards_selected.includes(Number(containers[i].dataset.cardId))){
                    containers[i].style.display= 'block';
                }
                else {
                    containers[i].style.display= 'none';

                }
            }
        }
        else {
            for (var i = 0; i < containers.length; i++) {
                containers[i].style.display= 'block';
            }

        }
    }

    for(i=0 ; i<checkboxes.length ; i++){
        checkboxes[i].addEventListener('change', updateListFromCheckboxes)
    }

    list.addEventListener('change', updateCheckboxesFromList)
    filterSelection.addEventListener('change', updateFilter)

</script>

</body>
</html>