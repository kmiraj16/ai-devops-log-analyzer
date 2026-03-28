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

def get_analysis_by_id(analysis_id):
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        dbname=os.getenv("DB_NAME", "logdb"),
        user=os.getenv("DB_USER", "loguser"),
        password=os.getenv("DB_PASSWORD", "logpass")
    )

    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT id, log_text, root_cause, suggestion, created_at
        FROM analyses
        WHERE id = %s
        """,
        (analysis_id,)
    )

    row = cursor.fetchone()

    cursor.close()
    conn.close()

    if row:
        return {
            "id": row[0],
            "log_text": row[1],
            "root_cause": row[2],
            "suggestion": row[3],
            "created_at": str(row[4])
        }

    return None