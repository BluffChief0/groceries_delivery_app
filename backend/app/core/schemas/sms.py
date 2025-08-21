from pydantic import BaseModel

class VerifyBody(BaseModel):
    code: str