#!/usr/bin/env python3

from bottle import run, post, request, response, get, route, template, static_file, redirect
import weasyprint

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

@get('/print') # or @route('/login', method='POST')
def get_print():
    return template('print_template', {'cards':storage.get_all_cards()})

@get('/print/<p>')
def get_print_page(p):
    per_page = 16
    # cards = storage.get_all_cards()[int(p)*per_page:(int(p)+1)*per_page]

    if p=='oops':
        all_cards = storage.get_all_cards()
        cards = []
        for i in range(8):
            cards.append(all_cards[i*4+1])

    return template('print_template', {'cards':cards})

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
    print(request.forms.title, request.forms.get('title'))
    print(get_card_infos(request.forms)['title'])
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
    print()
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

run(host='localhost', port=8000, debug=True)

