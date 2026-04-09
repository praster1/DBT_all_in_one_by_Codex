import argparse
from pathlib import Path
import duckdb

def replace_table(con, schema, table, csv_path):
    con.execute(f"create schema if not exists {schema}")
    con.execute(f"create or replace table {schema}.{table} as select * from read_csv_auto('{csv_path.as_posix()}')")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--db', default='lab.duckdb')
    parser.add_argument('--variant', choices=['day1', 'day2'], default='day1')
    parser.add_argument('--raw-dir', default='../raw_csv')
    args = parser.parse_args()

    base = Path(__file__).resolve().parent
    raw_dir = (base / args.raw_dir).resolve()
    con = duckdb.connect(args.db)

    replace_table(con, 'raw_retail', 'customers', raw_dir / 'retail_customers.csv')
    replace_table(con, 'raw_retail', 'products', raw_dir / 'retail_products.csv')
    replace_table(con, 'raw_retail', 'order_items', raw_dir / 'retail_order_items.csv')
    replace_table(con, 'raw_retail', 'orders', raw_dir / f'retail_orders_{args.variant}.csv')

    replace_table(con, 'raw_events', 'users', raw_dir / 'events_users.csv')
    replace_table(con, 'raw_events', 'events', raw_dir / f'events_{args.variant}.csv')

    replace_table(con, 'raw_billing', 'accounts', raw_dir / 'subscription_accounts.csv')
    replace_table(con, 'raw_billing', 'plans', raw_dir / 'subscription_plans.csv')
    replace_table(con, 'raw_billing', 'subscriptions', raw_dir / f'subscriptions_{args.variant}.csv')
    replace_table(con, 'raw_billing', 'invoices', raw_dir / 'subscription_invoices.csv')

    print(f'Loaded variant={args.variant} into {args.db}')

if __name__ == '__main__':
    main()
