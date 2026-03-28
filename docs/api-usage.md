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

## GET /results/{id}

Returns a stored analysis result by ID.

Example:
GET /results/1