import argparse
import logging
import random
import sys
import uuid

from pyodbc import connect

_DATA_TYPES = [
    'INT', 'TINYINT', 'SMALLINT', 'FLOAT', 'REAL', 'CHAR(5)', 'VARCHAR(25)',
    'TEXT', 'BINARY', 'DATE', 'TIME', 'DATETIME'
]

_COLUMN_NAMES = [
    'name', 'address', 'city', 'state', 'date_time', 'paragraph', 'randomdata',
    'person', 'credit_card', 'size', 'reason', 'school', 'food', 'location',
    'house', 'price', 'cpf', 'cnpj', 'passport', 'security_number',
    'phone_number', 'bank_account_number', 'ip_address', 'stocks'
]

_TABLE_NAMES = [
    'school_info', 'personal_info', 'persons', 'employees', 'companies',
    'store', 'home'
]

_SCHEMA_NAMES = [
    'school_warehouse', 'company_warehouse', 'on_prem_warehouse',
    'factory_warehouse', 'organization_warehouse'
]


def build_connection(database, host, user, password):
    return 'DRIVER={ODBC Driver 17 for SQL Server};' + \
            'SERVER={};DATABASE={};UID={};PWD={}'.format(
                host, database, user, password)


def get_conn(connection_args):
    return connect(
        build_connection(database=connection_args['database'],
                         host=connection_args['host'],
                         user=connection_args['user'],
                         password=connection_args['pass']))


def create_random_metadata(connection_args):
    conn = get_conn(connection_args)

    cursor = conn.cursor()

    for x in range(connection_args['number_schemas']):
        schema_name, schema_stmt = build_create_schema_statement()
        cursor.execute(schema_stmt)
        for y in range(connection_args['number_tables']):
            query = build_create_table_statement(schema_name)
            print('\n' + query)
            cursor.execute(query)
        conn.commit()

    cursor.close()


def get_random_schema_name():
    return random.choice(_SCHEMA_NAMES)


def build_create_schema_statement():
    schema_name = '{}{}'.format(get_random_schema_name(),
                                str(random.randint(1, 100000)))
    schema_stmt = 'CREATE SCHEMA {} '.format(schema_name)
    return schema_name, schema_stmt


def get_random_data_type():
    return random.choice(_DATA_TYPES)


def get_random_column_name():
    return random.choice(_COLUMN_NAMES)


def get_random_table_name():
    return random.choice(_TABLE_NAMES)


def build_create_table_statement(schema_name):
    table_stmt = 'CREATE TABLE {}.{}{} ( '.format(schema_name,
                                                  get_random_table_name(),
                                                  uuid.uuid4().hex[:8])
    table_stmt = '{}{}{} {}'.format(table_stmt, get_random_column_name(),
                                    str(random.randint(1, 100000)),
                                    get_random_data_type())
    for x in range(random.randint(1, 15)):
        table_stmt += ', {}{}'.format(get_random_column_name(),
                                      str(random.randint(1, 100000))) + \
            ' {}'.format(get_random_data_type())

    table_stmt = '{} )'.format(table_stmt)
    return table_stmt


def parse_args():
    parser = argparse.ArgumentParser(
        description='Command line generate random metadata into sqlserver')
    parser.add_argument(
        '--sqlserver-host',
        help='Your sqlserver server host, this is required even'
        ' for the raw_metadata_csv,'
        ' so we are able to map the created entries'
        ' resource with the sqlserver host',
        required=True)
    parser.add_argument('--sqlserver-user',
                        help='Your sqlserver credentials user')
    parser.add_argument('--sqlserver-pass',
                        help='Your sqlserver credentials password')
    parser.add_argument('--sqlserver-database',
                        help='Your sqlserver database name')
    parser.add_argument('--number-schemas',
                        help='Number of schemas to create',
                        type=int,
                        default=4)
    parser.add_argument('--number-tables',
                        help='Number of tables to create',
                        type=int,
                        default=250)
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    # Enable logging
    logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

    create_random_metadata({
        'database': args.sqlserver_database,
        'host': args.sqlserver_host,
        'user': args.sqlserver_user,
        'pass': args.sqlserver_pass,
        'number_schemas': args.number_schemas,
        'number_tables': args.number_tables
    })
