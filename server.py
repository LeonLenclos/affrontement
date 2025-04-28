#!/usr/bin/env python3

from bottle import run, post, request, response, get, route, template, static_file, redirect
import weasyprint
import os
import random

import storage

storage.create_tables()

def get_card_infos(infos):
    return dict(
        title=infos.title or 'Sans titre',
        primary_types=[int(id) for id in infos.getall('primary_types')],
        secondary_types=[int(id) for id in infos.getall('secondary_types')],
        card_rules=[{
            "rule_type":int(infos.get('rule{}_type'.format(i), 1)),
            "text":infos.getunicode('rule{}_text'.format(i), '')
        } for i in range(10) if infos.get('rule{}_text'.format(i))]
    )


@get('/card') # or @route('/login', method='POST')
def get_card():
    return template('card_template', get_card_infos(request.forms))

@get('/cards') # or @route('/login', method='POST')
def get_cards():
    return template('cards_template', {'cards':storage.get_all_cards()})



def print_montage(cards):
    file_names = []
    for i, card in enumerate(cards):
        string = template('card_template', card)
        css = [
            weasyprint.CSS('www/style.css'),
            weasyprint.CSS('www/card.css'),
            weasyprint.CSS('www/print-card.css'),
        ]
        html = weasyprint.HTML(string=string)
        file_name = 'tmp/card-{}.pdf'.format(i)
        file_names.append(file_name)
        pdf = html.write_pdf(file_name, stylesheets=css)

    montage_command = 'montage -density {dpi} {input} -geometry +0+0 -tile {tile} -page 2480x3508+20+20 {out}'
    os.system(montage_command.format(
        dpi=300,
        input=' '.join(file_names),
        tile='3x3',
        out='tmp/montage.pdf'
    ))




    return static_file('montage.pdf', 'tmp')



@post('/print') # or @route('/login', method='POST')
def post_print():
    print('Imprimer :',request.forms.cards)
    cards = storage.get_cards(request.forms.cards)
    return print_montage(cards)


@post('/booster') # or @route('/login', method='POST')
def post_booster():
    print('Imprimer en booster :', request.forms.cards)

    # Séparer lambda de spéciales
    special_cards = []
    lambda_cards = []
    for card in storage.get_cards(request.forms.cards):
        secondary_types = (storage.get_secondary_type(type_id) for type_id in card['secondary_types'])
        if 'lambda' in secondary_types:
            lambda_cards.append(card)
        else:
            special_cards.append(card)

    # Tirer 5 lambda au pif
    random_lambda = [random.choice(lambda_cards) for _ in range(5)]
    # Tirer 5 spéciales sans prendre deux fois la même
    random_specials = random.sample(special_cards, 5)

    # monter
    return print_montage(random_lambda+random_specials)


@get('/cards.pdf') # or @route('/login', method='POST')
def get_pdf():
    html = weasyprint.HTML(string=get_print())
    pdf = html.write_pdf(presentational_hints=True, stylesheets=get_static('style.css'))
    # pdf = html.write_pdf(presentational_hints=True, stylesheets=css, attachments=imgs)
    with open('cards.pdf', 'wb') as fichier:
        fichier.write(pdf)
    return static_file('cards.pdf', '.')



@get('/create')
def get_create():
    return template('create_template', get_card_infos(request.forms))

@post('/create')
def post_create():
    id = storage.create_card(**get_card_infos(request.forms))
    redirect('/modify/' + str(id))



@get('/modify/<id>')
def get_modify(id):
    card_infos = storage.get_card(id)
    card_infos.update({'id':id})
    return template('modify_template', card_infos)

@post('/modify/<id>')
def post_modify(id):
    storage.modify_card(id=id, **get_card_infos(request.forms))
    return get_modify(id)

@get('/delete/<id>')
def get_delete(id):
    return template('delete_template', storage.get_card(id))

@post('/delete/<id>')
def post_delete(id):
    storage.delete_card(id)
    redirect('/')





@get('/<path>')
def get_static(path):
    return static_file(path, 'www')

@get('/')
def get_index():
    redirect('/cards')
    # return get_static('/index.html')



def exporter_pdf():
        # imgs = [os.path.join(img_dir, f) for f in os.listdir(img_dir)]
        html = weasyprint.HTML(string=get_print())
        pdf = html.write_pdf(presentational_hints=True, stylesheets=css, attachments=imgs)
        with open(nom_fichier, 'wb') as fichier:
            fichier.write(pdf)

run(host='192.168.1.39', port=8081, debug=True)
#run(host='localhost', port=8000, debug=True)
