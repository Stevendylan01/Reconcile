from pathlib import Path

from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

app = FastAPI(title="Disaster Recovery Portal")
templates = Jinja2Templates(directory=Path(__file__).parent / "templates")

DEMO_REQUESTS = (
    {
        "project": "Alder County · Road repairs",
        "evidence": "Proof of payment",
        "description": "Provide payment confirmation for the culvert replacement invoice.",
        "status": "Open",
    },
    {
        "project": "Alder County · Road repairs",
        "evidence": "Itemized contractor invoice",
        "description": "Review the invoice for debris removal along Mill Road.",
        "status": "Submitted",
    },
    {
        "project": "Juniper County · Facility repairs",
        "evidence": "Purchase order",
        "description": "Provide the approved purchase order for emergency roof repairs.",
        "status": "Needs clarification",
    },
)


@app.get("/", response_class=HTMLResponse)
def request_queue(request: Request):
    return templates.TemplateResponse(
        request=request,
        name="index.html",
        context={"evidence_requests": DEMO_REQUESTS},
    )


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
