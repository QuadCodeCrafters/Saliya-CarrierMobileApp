from datetime import date
from decimal import Decimal
from fastapi import FastAPI, HTTPException, Depends, status
from pydantic import BaseModel
from typing import Annotated, Optional
from database import engine, SessionLocal
from sqlalchemy.orm import Session
import models

app = FastAPI()
models.Base.metadata.create_all(bind=engine)

class EmployeeBase(BaseModel):
    EmployeeID: int
    NationalIdentificationNumber: Optional[str]
    Name: str
    DOB: Optional[date]
    Salary: Optional[Decimal]
    Status: Optional[str]
    Mail: Optional[str]
    Position: Optional[str]
    Address: Optional[str]
    Phone: Optional[str]
    HireDate: Optional[date]
    ImagePath: Optional[str]

class EmployeeBase2(BaseModel):
    Status: Optional[str]

    class Config:
        orm_mode = True

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

db_dependency = Annotated[Session, Depends(get_db)]

@app.get("/employees/{em_id}", status_code=status.HTTP_200_OK)
async def read_employee(em_id: int, db: db_dependency):
    employee = db.query(models.Employee).filter(models.Employee.EmployeeID == em_id).first()
    if employee is None:
        raise HTTPException(status_code=404, detail="Employee not found")
    return employee

@app.get("/employeeLogin/{em_ID_NO}/{em_name}", status_code=status.HTTP_200_OK)
async def read_employee(em_ID_NO: str,em_name: str, db: db_dependency):
    employee = db.query(models.Employee).filter(models.Employee.NationalIdentificationNumber == em_ID_NO,models.Employee.Name == em_name).first()
    if employee is None:
        raise HTTPException(status_code=404, detail="Employee not found")
    return employee


#Update part (status)
@app.put("/employeeUpdate/{em_id}")
def update_user(em_id: int, em_data: EmployeeBase2):
    db = SessionLocal()
    employee = db.query(models.Employee).filter(models.Employee.EmployeeID == em_id).first()

    if not employee:
        db.close()
        raise HTTPException(status_code=404, detail="employee not found")

    # Update employee details
    employee.Status = em_data.Status
    
    db.commit()
    db.refresh(employee)
    db.close()
    
    return {"message": "User updated successfully", "user": employee}