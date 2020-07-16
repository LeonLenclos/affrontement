import sqlite3




def connect():
    return sqlite3.connect('rules.db')



def create_tables():

    conn = connect()
    c = conn.cursor()

    c.execute('''CREATE TABLE IF NOT EXISTS cards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title text,
            primary_types text,
            secondary_types text,
            card_rules text)''')

    c.execute('''CREATE TABLE IF NOT EXISTS primary_types (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name text
        )''')

    c.execute('''CREATE TABLE IF NOT EXISTS secondary_types (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name text
        )''')

    c.execute('''CREATE TABLE IF NOT EXISTS card_rule_types (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name text
        )''')

    c.execute('''CREATE TABLE IF NOT EXISTS card_rules (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type text,
            txt text
        )''')

    c.execute('''CREATE TABLE IF NOT EXISTS keywords (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name text
        )''')

    conn.commit()
    conn.close()



def list_to_db(list_):
    return ','.join(str(v) for v in list_)

def list_from_db(string):
    return [int(v) for v in string.split(',') if v != '']

#######################################
# CREATE


def create_card(title, primary_types, secondary_types, card_rules):
    conn = connect()
    c = conn.cursor()

    rules_list = []
    for rule in card_rules:
        rules_list.append(create_rule(rule['rule_type'], rule['text']))

    card = [title, list_to_db(primary_types), list_to_db(secondary_types), list_to_db(rules_list)]

    c.execute('''INSERT INTO cards (title, primary_types, secondary_types, card_rules)
        VALUES (?, ?, ?, ?)''', card)

    id = c.lastrowid
    conn.commit()
    conn.close()
    return id


def create_rule(rule_type, text):
    conn = connect()
    c = conn.cursor()

    rule = [rule_type, text]

    c.execute('''INSERT INTO card_rules (type, txt)
        VALUES (?, ?)''', rule)


    id = c.lastrowid
    conn.commit()
    conn.close()
    return id

def create(table, name):
    conn = connect()
    c = conn.cursor()

    c.execute('''INSERT INTO {} (name)
        VALUES (?)'''.format(table), [name])

    id = c.lastrowid
    conn.commit()
    conn.close()
    return id

def create_primary_type(name):
    return create('primary_types', name)

def create_secondary_type(name):
    return create('secondary_types', name)

def create_card_rule_type(name):
    return create('card_rule_types', name)

def create_keyword(name):
    return create('keywords', name)




#######################################
# FROM DB

def card_from_db(result):
    card = dict(zip(['id', 'title', 'primary_types', 'secondary_types', 'card_rules'], result))
    card['primary_types'] = list_from_db(card['primary_types'])
    card['secondary_types'] = list_from_db(card['secondary_types'])
    card['card_rules'] = [get_rule(id) for id in list_from_db(card['card_rules'])]

    return card




#######################################
# GET


def get_card(id):
    conn = connect()
    c = conn.cursor()

    c.execute('''SELECT id, title, primary_types, secondary_types, card_rules
        FROM cards WHERE id = ?''', [id])

    card = card_from_db(c.fetchone())
    conn.commit()
    conn.close()
    return card


def get_rule(id):
    conn = connect()
    c = conn.cursor()

    c.execute('''SELECT type, txt
        FROM card_rules WHERE id = ?''', [id])


    rule = dict(zip(['rule_type', 'text'], c.fetchone()))
    rule['rule_type'] = int(rule['rule_type'])

    conn.commit()
    conn.close()
    return rule

def get(table, id):

    print('get', id, 'from', table)
    conn = connect()
    c = conn.cursor()

    c.execute('''SELECT name
        FROM {} WHERE id = ?'''.format(table), [id])

    name = c.fetchone()[0]
    conn.commit()
    conn.close()
    return name

def get_primary_type(id):
    return get('primary_types', id)

def get_secondary_type(id):
    return get('secondary_types', id)

def get_card_rule_type(id):
    return get('card_rule_types', id)

def get_keyword(id):
    return get('keywords', id)



#######################################
# MODIFY / DELETE


def modify_card(id, title, primary_types, secondary_types, card_rules):
    conn = connect()
    c = conn.cursor()

    rules_list = []
    for rule in card_rules:
        rules_list.append(create_rule(rule['rule_type'], rule['text']))

    card = [title, list_to_db(primary_types), list_to_db(secondary_types), list_to_db(rules_list), id]

    c.execute('''UPDATE cards SET title = ?, primary_types = ?, secondary_types = ?, card_rules = ?
         WHERE id = ?''', card)

    conn.commit()
    conn.close()
    return

def delete_card(id):
    conn = connect()
    c = conn.cursor()

    c.execute('''DELETE FROM cards WHERE id = ?''', [id])

    conn.commit()
    conn.close()
    return





#######################################
# GET_ALL


def get_all_cards():
    conn = connect()
    c = conn.cursor()

    c.execute('''SELECT id, title, primary_types, secondary_types, card_rules
        FROM cards''')

    cards = c.fetchall()

    cards = [card_from_db(result) for result in cards]

    conn.commit()
    conn.close()
    return cards

def get_all(table):
    conn = connect()
    c = conn.cursor()

    c.execute('''SELECT id, name
        FROM {}'''.format(table))

    element = [{'id':result[0],'name':result[1]} for result in c.fetchall()]
    conn.commit()
    conn.close()
    return element

def get_all_primary_types():
    return get_all('primary_types')

def get_all_secondary_types():
    return get_all('secondary_types')

def get_all_card_rule_types():
    return get_all('card_rule_types')

def get_all_keywords():
    return get_all('keywords')

def get_all_keywords_extended():
    return get_all_primary_types()\
        + get_all_secondary_types()\
        + get_all_card_rule_types()\
        + get_all_keywords()

###############"

print(get_all_keywords_extended())


def count(table):
    conn = connect()
    c = conn.cursor()

    count = c.execute("SELECT COUNT() FROM {}".format(table)).fetchone()[0]

    conn.commit()
    conn.close()
    return count
