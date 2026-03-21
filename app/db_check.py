import os
import psycopg2

def test_db_connection():
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        dbname=os.getenv("DB_NAME", "logdb"),
        user=os.getenv("DB_USER", "loguser"),
        password=os.getenv("DB_PASSWORD", "logpass")
    )
    conn.close()
    return True