from db_check import test_db_connection
from db_check import insert_analysis
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
def health_check():
    db_status = "ok"
    try:
        test_db_connection()
    except Exception:
        db_status = "error"

    return {
        "status": "ok",
        "database": db_status
    }

@app.post("/analyze")
def analyze_log(data: dict):
    log = data.get("log", "").lower()

    if "timeout" in log:
        root_cause = "Service timeout"
        suggestion = "Check network connectivity or service availability"
        insert_analysis(log, root_cause, suggestion)
        return {
            "root_cause": root_cause,
            "suggestion": suggestion
        }

    elif "database" in log:
        root_cause = "Database connection issue"
        suggestion = "Check DB health and credentials"
        insert_analysis(log, root_cause, suggestion)
        return {
            "root_cause": root_cause,
            "suggestion": suggestion
        }

    else:
        root_cause = "Unknown"
        suggestion = "Further investigation required"
        insert_analysis(log, root_cause, suggestion)
        return {
            "root_cause": root_cause,
            "suggestion": suggestion
        }
