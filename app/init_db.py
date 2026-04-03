import os
import psycopg2

def get_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "5432")),
        dbname=os.getenv("DB_NAME", "logdb"),
        user=os.getenv("DB_USER", "loguser"),
        password=os.getenv("DB_PASSWORD", "logpass"),
    )

def run_schema():
    with open("app/sql/init.sql", "r", encoding="utf-8") as f:
        schema_sql = f.read()

    conn = get_connection()
    try:
        with conn:
            with conn.cursor() as cursor:
                cursor.execute(schema_sql)
        print("Schema initialized successfully.")
    finally:
        conn.close()

if __name__ == "__main__":
    run_schema()