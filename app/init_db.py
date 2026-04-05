import os
import psycopg2
from psycopg2 import OperationalError

def get_connection():
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST"),
            port=int(os.getenv("DB_PORT", "5432")),
            dbname=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
        )
        print("✅ Database connection established.")
        return conn
    except OperationalError as e:
        print("❌ Failed to connect to database.")
        print(e)
        raise


def get_sql_file_path():
    """
    Resolve absolute path to sql/init.sql safely,
    regardless of working directory or environment.
    """
    base_dir = os.path.dirname(os.path.abspath(__file__))
    sql_path = os.path.join(base_dir, "sql", "init.sql")

    if not os.path.exists(sql_path):
        raise FileNotFoundError(f"SQL file not found at: {sql_path}")

    return sql_path


def run_schema():
    try:
        sql_path = get_sql_file_path()

        print(f"📄 Loading schema from: {sql_path}")

        with open(sql_path, "r", encoding="utf-8") as f:
            schema_sql = f.read()

        conn = get_connection()

        try:
            with conn:
                with conn.cursor() as cursor:
                    cursor.execute(schema_sql)
            print("✅ Schema initialized successfully.")
        finally:
            conn.close()
            print("🔒 Database connection closed.")

    except Exception as e:
        print("❌ Schema initialization failed.")
        print(e)
        raise


if __name__ == "__main__":
    print("🚀 Starting DB initialization...")
    run_schema()