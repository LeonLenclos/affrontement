<!DOCTYPE html>
% import storage

<link rel="stylesheet" type="text/css" href="/card.css">
<link rel="stylesheet" type="text/css" href="/font.css">
<div class="card">
<div class=content>
    
    <div class="header">
        <div class=title>{{title.title()}}</div>
        <div class=types>
            <span class=primary_types>{{', '.join([storage.get_primary_type(id).title() for id in primary_types])}}</span>

            % if len(secondary_types):
            <span class=secondary_types>({{', '.join([storage.get_secondary_type(id).title() for id in secondary_types])}})</span>
            % end
        </div>
    </div>

    <div class=illu>
        
    </div>

    <div class=rules>
        % for card_rule in card_rules:
            <div class=rule>
                <div class=rule_type>{{storage.get_card_rule_type(card_rule['rule_type'])}}</div>
                <div class=rule_text>{{card_rule['text']}}</div>
            </div>
        % end
    </div>

    <div class="footer">
        Affrontement 2020
    </div>
</div>
</div>