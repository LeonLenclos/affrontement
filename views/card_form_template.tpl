<!DOCTYPE html>

% import storage

<form action="#" method="post">

    <label for="title">Titre:</label>
    <input name="title" value="{{title.title()}}"><br>

    <label for="title">Types principaux:</label>
    <select name="primary_types" size=5 multiple>
        % for type in storage.get_all_primary_types():

            % id = type['id']
            % selected = 'selected' if id in primary_types else ''

            <option type=int value="{{id}}" {{selected}}>{{type['name'].title()}}</option>
        % end
    </select>

    <label for="title">Types secondaires:</label>
    <select name="secondary_types" size=5 multiple>
        % for type in storage.get_all_secondary_types():

            % id = type['id']
            % selected = 'selected' if id in secondary_types else ''

            <option type=int value="{{id}}" {{selected}}>{{type['name'].title()}}</option>
        % end
    </select>


    % for i in range(10):


    % text = card_rules[i]['text'] if i < len(card_rules) else ''
    % type_id = card_rules[i]['rule_type'] if i < len(card_rules) else 0


        <div class="rule_form">

            Règle {{i}}<br>


            <label>Type de règle:</label>
            <select name="rule{{i}}_type">
                % for type in storage.get_all_card_rule_types():
                    % selected = 'selected' if type_id == type['id'] else ''
                    <option type=int value="{{type['id']}}" {{selected}}>{{type['name'].title()}}</option>
                % end
            </select>

            <label for="title">Texte de la règle:</label>
            <input name="rule{{i}}_text" value="{{text}}"><br>


        </div>
    % end

    <input type="submit">

</form> 

