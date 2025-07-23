from sqlalchemy import Column, Integer, String, Date, Enum, Text, DECIMAL
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Employee(Base):
    __tablename__ = 'employee'

    EmployeeID = Column(Integer, primary_key=True, autoincrement=True, nullable=False)
    NationalIdentificationNumber = Column(String(50), nullable=True)
    Name = Column(String(100), nullable=False)
    DOB = Column(Date, nullable=True)
    Salary = Column(DECIMAL(10, 2))
    Status = Column(Enum('Active', 'Inactive'), nullable=True)
    Mail = Column(String(100), nullable=True, unique=True)
    Position = Column(String(50), nullable=True)
    Address = Column(Text, nullable=True)
    Phone = Column(String(15), nullable=True)
    HireDate = Column(Date, nullable=True)
    ImagePath = Column(String(255), nullable=True)