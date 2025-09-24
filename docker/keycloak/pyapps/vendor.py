# vendor/app.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()
db = {}

class User(BaseModel):
    id: str
    email: str
    displayName: str
    status: str

@app.post("/users")
def create_user(user: User):
    if user.id in db:
        raise HTTPException(status_code=409, detail="exists")
    db[user.id] = user.dict()
    return db[user.id]

@app.get("/users/{user_id}")
def get_user(user_id: str):
    if user_id not in db:
        raise HTTPException(status_code=404, detail="not found")
    return db[user_id]

@app.patch("/users/{user_id}")
def update_user(user_id: str, user: User):
    if user_id not in db:
        raise HTTPException(status_code=404, detail="not found")
    db[user_id].update(user.dict())
    return db[user_id]

@app.delete("/users/{user_id}")
def delete_user(user_id: str):
    db.pop(user_id, None)
    return {"deleted": user_id}
