POST /analyze

Example request:

{
"log": "database connection timeout"
}

Example response:

{
"root_cause": "Service timeout",
"suggestion": "Check network connectivity or service availability"
}
