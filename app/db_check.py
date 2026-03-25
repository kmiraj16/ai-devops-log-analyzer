import os
import psycopg2

def test_db_connection():
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST", "localhost"),
            dbname=os.getenv("DB_NAME", "logdb"),
            user=os.getenv("DB_USER", "loguser"),
            password=os.getenv("DB_PASSWORD", "logpass")
        )
        conn.close()
        return True
    except Exception as e:
        print("DB connection failed:", e)
        return False


def insert_analysis(log_text, root_cause, suggestion):
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        dbname=os.getenv("DB_NAME", "logdb"),
        user=os.getenv("DB_USER", "loguser"),
        password=os.getenv("DB_PASSWORD", "logpass")
    )

    cursor = conn.cursor()

    cursor.execute(
        """
        INSERT INTO analyses (log_text, root_cause, suggestion)
        VALUES (%s, %s, %s)
        """,
        (log_text, root_cause, suggestion)
    )

    conn.commit()
    cursor.close()
    conn.close()