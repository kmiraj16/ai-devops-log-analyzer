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
    return {"status": "ok"}

@app.post("/analyze")
def analyze_log(data: dict):
    log = data.get("log", "").lower()

    if "timeout" in log:
        return {
            "root_cause": "Service timeout",
            "suggestion": "Check network connectivity or service availability"
        }

    elif "database" in log:
        return {
            "root_cause": "Database connection issue",
            "suggestion": "Check DB health and credentials"
        }

    else:
        return {
            "root_cause": "Unknown",
            "suggestion": "Further investigation required"
        }
