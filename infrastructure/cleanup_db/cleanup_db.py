import argparse
import logging
import sys
import uuid

from pyodbc import connect

QUERY = """
SELECT  DISTINCT t.table_schema as schema_name,
                 t.table_name as table_name
    FROM information_schema.tables t
    WHERE t.table_schema NOT IN ('dbo')
    ORDER BY t.table_schema;
"""


def get_conn(connection_args):
    return connect(
        build_connection(database=connection_args['database'],
                         host=connection_args['host'],
                         user=connection_args['user'],
                         password=connection_args['pass']))


def build_connection(database, host, user, password):
    return 'DRIVER={ODBC Driver 17 for SQL Server};' + \
            'SERVER={};DATABASE={};UID={};PWD={}'.format(
                host, database, user, password)


def cleanup_metadata(connection_args):
    conn = get_conn(connection_args)

    cursor = conn.cursor()
    cursor.execute(QUERY)
    rows = cursor.fetchall()
    for row in rows:
        schema_name = row[0]
        table_name = row[1]
        table_stmt = build_drop_table_statement(schema_name, table_name)
        cursor.execute(table_stmt)
        print('Cleaned table: {}.{}'.format(schema_name, table_name))
        conn.commit()

    cursor.close()


def build_drop_table_statement(schema_name, table_name):
    table_stmt = 'DROP TABLE {}.{};'.format(schema_name, table_name)
    return table_stmt


def parse_args():
    parser = argparse.ArgumentParser(
        description='Command line to cleanup metadata from sqlserver')
    parser.add_argument('--sqlserver-host',
                        help='Your sqlserver server host',
                        required=True)
    parser.add_argument('--sqlserver-user',
                        help='Your sqlserver credentials user',
                        required=True)
    parser.add_argument('--sqlserver-pass',
                        help='Your sqlserver credentials password',
                        required=True)
    parser.add_argument('--sqlserver-database',
                        help='Your sqlserver database name',
                        required=True)
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    # Enable logging
    logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

    cleanup_metadata({
        'database': args.sqlserver_database,
        'host': args.sqlserver_host,
        'user': args.sqlserver_user,
        'pass': args.sqlserver_pass
    })
