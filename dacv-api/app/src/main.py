from fastapi import FastAPI
from mangum import Mangum

app = FastAPI(
    title="Dacv API"
)

@app.get("/health")
def health():
    return {"status": "ok"}