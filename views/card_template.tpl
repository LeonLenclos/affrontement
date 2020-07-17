<!DOCTYPE html>
% import storage
% import re

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

                % txt = card_rule['text']
                % for keyword in storage.get_all_keywords_extended():
                    % insensitive_keyword = re.compile(re.escape(keyword['name']), re.IGNORECASE)

                    % txt = insensitive_keyword.sub('<u>'+keyword['name'].capitalize()+'</u>', txt)
                % end
                <div class=rule_text>{{!txt}}</div>
            </div>
        % end
    </div>

    <div class="footer">
        Affrontement 2020
    </div>
</div>
</div>