import os
import psycopg2

def get_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=int(os.getenv("DB_PORT", "5432")),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
    )

def main():
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT table_schema, table_name
                FROM information_schema.tables
                WHERE table_schema = 'public'
                ORDER BY table_name;
            """)
            rows = cur.fetchall()
            print("Tables in public schema:")
            for schema, table in rows:
                print(f"- {schema}.{table}")
    finally:
        conn.close()

if __name__ == "__main__":
    main()