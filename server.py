#!/usr/bin/env python3

from bottle import run, post, request, response, get, route, template, static_file, redirect

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
    print(storage.get_all_cards())  
    return template('cards_template', {'cards':storage.get_all_cards()})

@get('/print') # or @route('/login', method='POST')
def get_print():
    print(storage.get_all_cards())  
    return template('print_template', {'cards':storage.get_all_cards()})



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

run(host='localhost', port=8000, debug=True)
