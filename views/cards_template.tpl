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
    <label>Ne montrer que la selection:</label>
    <input id="filter-selection" type="checkbox">
    <a href="#" id="permanent-link">Lien permanant vers cette selection</a>
    <form action="/print" method="post">
        <label for="cards">Selection:</label>
        <input id="cards-list" name="cards" size=100>
        <input type="submit" value="Imprimer"></a>
    </form>
</div>

<div class="editor">

% for card in cards:
<div class="card_container" data-card-id="{{card['id']}}">

    % title = card['title']
    % primary_types = card['primary_types']
    % secondary_types = card['secondary_types']
    % card_rules = card['card_rules']
    % include('card_template.tpl')
    <div class="card_edit_menu">
        <small>{{card['id']}}</small> |
        <a href="/modify/{{card['id']}}">modifier</a> | 
        <a href="/delete/{{card['id']}}">suprimer</a> |
<!--         <small><input class="card-selection" type="checkbox" value="{{card['id']}}">{{card['id']}}</small>
 -->        <input size=2 data-card-id="{{card['id']}}" class="card-selection" name="amount" value=0>
            <button class="amount-button" data-card-id="{{card['id']}}" data-operation="+">+</button>
            <button class="amount-button" data-card-id="{{card['id']}}" data-operation="-">-</button>
            <button class="amount-button" data-card-id="{{card['id']}}" data-operation="0">0</button>
    </div>
</div>
% end
</div>




<script>


    let filterSelection = document.querySelector('#filter-selection');
    let amountInputs = document.querySelectorAll('.card-selection');
    let amountButtons = document.querySelectorAll('.amount-button');
    let list = document.querySelector('#cards-list')
    let permanentLink = document.querySelector('#permanent-link');

    selectionTextToArrObj = (text) => {
        return text.split(',').map((s)=>{
            let cardId = Number(s.split('x')[0])
            let cardNumber = Number(s.split('x')[1]) || 1
            return {
                id:cardId,
                amount:cardNumber
            };
        });
    }

    selectionArrObjToText = (arrobj) => {
        let text = '';
        for (var i = 0; i < arrobj.length; i++) {
            if(arrobj[i].amount == 1){
                text += arrobj[i].id + ','
            } else {
                text += arrobj[i].id + 'x' + arrobj[i].amount + ','
            }
        }
        return text;
    }

    updateListFromAmountInputs = (e) => {
        let arrobj= []
        for (var i = 0; i < amountInputs.length; i++) {
            let amount = Number(amountInputs[i].value);
            if(amount>0){
                arrobj.push({
                    id:Number(amountInputs[i].dataset.cardId),
                    amount:amount
                })
            }
        }
        console.log(arrobj)
        list.value = selectionArrObjToText(arrobj);
    }

    updateAmountInputsFromList = (e) => {
        let arrobj = selectionTextToArrObj(list.value);

        for (var i = 0; i < amountInputs.length; i++) {
            amountInputs[i].value = 0;
            for (var j = 0; j < arrobj.length; j++) {
                if(arrobj[j].id == Number(amountInputs[i].dataset.cardId)){
                    amountInputs[i].value = arrobj[j].amount
                }
            }
        }
    }
    
    updateSelected = (e) => {
        let containers = document.querySelectorAll('.card_container')
        let arrobj = selectionTextToArrObj(list.value);

        for (var i = 0; i < containers.length; i++) {
            containers[i].classList.remove("selected");
            let sel = false;
            for (var j = 0; j < arrobj.length; j++) {
                if(arrobj[j].id == Number(containers[i].dataset.cardId)){
                    sel = true;
                    break;
                }
            }
            if(sel){
                containers[i].classList.add("selected");
            }
        }  
    };

    updateFilter = (e) => {
        let containers = document.querySelectorAll('.card_container')

        for (var i = 0; i < containers.length; i++) {
            if (filterSelection.checked && !containers[i].classList.contains('selected')) {
                containers[i].style.display= 'none';
            }
            else {
                containers[i].style.display= 'block';
            }
        }
    };

    amountButtonClick = (e) => {
        let cardId = e.target.dataset.cardId;
        let operation = e.target.dataset.operation;
        let amountInput = document.querySelector("input[data-card-id='"+cardId+"']");
        if (operation=='+'){
            amountInput.value++;
        }
        if (operation=='-'){
            amountInput.value--;
        }
        if (operation=='0'){
            amountInput.value=0;
        }
        updateListFromAmountInputs();
        updateSelected();
        updateFilter();
    }

    selection = new URLSearchParams(document.location.search).get('selection');

    if(selection){
        list.value=selection;
        filterSelection.checked=true;
        updateAmountInputsFromList();
        updateSelected();
        updateFilter();
    }

    permanentLink.addEventListener('click', ()=>{
        document.location = document.location.href.split('?')[0] + '?selection=' + list.value;
    })

    for (var i = 0; i < amountButtons.length; i++) {
        amountButtons[i].addEventListener('click', amountButtonClick);
    }

    for(i=0 ; i<amountInputs.length ; i++){
        amountInputs[i].addEventListener('change',()=>{
            updateListFromAmountInputs();
            updateSelected();
            updateFilter();
        }); 
    }

    list.addEventListener('change', ()=>{
        updateAmountInputsFromList();
        updateSelected();
        updateFilter();
    });
    filterSelection.addEventListener('change', ()=>{
        updateSelected();
        updateFilter();
    })


</script>

</body>
</html>