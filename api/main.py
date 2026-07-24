from pathlib import Path
from typing import List
import json

from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

from database import db
from models import Inventory


app = FastAPI(
    title="Butcher Shop Inventory API"
)


BASE_DIR = Path(__file__).resolve().parent


templates = Jinja2Templates(
    directory=str(BASE_DIR / "templates")
)



@app.on_event("startup")
def startup():

    db.init()



@app.get(
    "/api/health"
)
def health():

    return {
        "status": "ok"
    }




@app.post(
    "/sync"
)
def sync_inventory(
    inventories: list[Inventory]
):

    received = []


    for inventory in inventories:

        db.save_inventory(
            inventory
        )

        received.append(
            inventory.uuid
        )


    return {

        "status": "received",

        "count": len(received),

        "uuids": received

    }





@app.get(
    "/",
    response_class=HTMLResponse
)
def dashboard(
    request: Request
):

    inventories = db.list_inventories()

    return templates.TemplateResponse(
        request=request,
        name="index.html",
        context={
            "inventories": inventories
        }
    )





@app.get(
    "/inventory/{uuid}",
    response_class=HTMLResponse
)
def inventory_detail(
    request: Request,
    uuid: str
):

    inventory = (
        db.get_inventory(uuid)
    )


    if inventory is None:

        raise HTTPException(
            status_code=404,
            detail="Inventory not found"
        )


    return templates.TemplateResponse(
        request=request,
        name="inventory.html",
        context={
            "inventory": inventory
        }
    )

@app.get("/debug/{uuid}")
def debug(uuid: str):
    return db.get_inventory(uuid)


@app.get("/debug/last")
def debug_last():

    cursor = db.connection.cursor()

    cursor.execute("""
        SELECT data_json
        FROM inventories
        ORDER BY created_at DESC
        LIMIT 1
    """)

    row = cursor.fetchone()

    if row is None:
        return {}

    return json.loads(row["data_json"])