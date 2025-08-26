<Query Kind="Statements">
  <Connection>
    <ID>749b9e29-3faf-4e0d-a9b1-e0e1776ae0d6</ID>
    <Persist>true</Persist>
    <Driver Assembly="IQDriver" PublicKeyToken="5b59726538a49684">IQDriver.IQDriver</Driver>
    <Provider>Devart.Data.Oracle</Provider>
    <CustomCxString>AQAAANCMnd8BFdERjHoAwE/Cl+sBAAAA1qS0JJxggkqcLfPms2SzZQAAAAACAAAAAAADZgAAwAAAABAAAACOUh27ymlK2X/Iw3TAuJ1tAAAAAASAAACgAAAAEAAAABv3DbzS9/G4xWIJVjOy/35oAAAAehFk+zD++1VSOuTHrNTsmQ47PrcoKqP6ykHmxenWLT1Dg4iBEsEaDCxvuqVbe8iMFnSGZ0LIWiGeO/EQU80Cfq5a5VAljOtZn0Qm0tlmIT1kY3OmclK7gfclxONn6OQrBibf9ZiJPusUAAAAwxwdeMAHHSfHkAQMJHIsjcWqGVQ=</CustomCxString>
    <UserName>GROUP29</UserName>
    <Server>hpc-oracle01.massey.ac.nz</Server>
    <EncryptCustomCxString>true</EncryptCustomCxString>
    <Password>AQAAANCMnd8BFdERjHoAwE/Cl+sBAAAA1qS0JJxggkqcLfPms2SzZQAAAAACAAAAAAADZgAAwAAAABAAAACBP/Cp1xRJ2is1zgBLbD0gAAAAAASAAACgAAAAEAAAACmoEJiU4VXpjVG4W3zuZXwIAAAAMU6/tSuczgUUAAAA5yZnHD453Roix5zX2R6d+eXmUCQ=</Password>
    <DriverData>
      <StripUnderscores>true</StripUnderscores>
      <QuietenAllCaps>false</QuietenAllCaps>
      <ConnectAs>Default</ConnectAs>
      <UseOciMode>false</UseOciMode>
      <SID>sncs</SID>
      <Port>1521</Port>
    </DriverData>
  </Connection>
</Query>

// a
// List faculty members who earn 80,000 or over. 

var a2_a = 
	from f in FACULTies
    where f.FSALARY >= 80000
	select new
		{F_FULL_NAME = f.FFIRST + " " + f.FMI + " " + f.FLAST,
		f.FSALARY};
a2_a.Dump();


// b
// List courses that have MIS in their course number. 

var a2_b = 
	from c in COURSEs
    where c.COURSENO.Contains("MIS")
	select new
		{c.COURSENO, c.COURSENAME, c.CREDITS};

a2_b.Dump();


// c
// List faculty members and their location details. 

var a2_c = 
	from f in FACULTies
	join l in LOCATIONs
	on f.LOCID equals l.LOCID
	
	select new
		{l.LOCID, 
		F_FULL_NAME = f.FFIRST + " " + f.FMI + " " + f.FLAST,
		l.BLDGCODE, l.ROOM};

a2_c.Dump();


// d
// Display the total number of rooms in each building.

var a2_d = 
	from l in LOCATIONs
	group l.ROOM by l.BLDGCODE into r
	
	select new
		{BLDGCODE = r.Key,
		TotalRooms = r.Count()};

a2_d.Dump();


// e
// Display total number of students supervised by each faculty in the order of faculty last name. 

var a2_e = 
	from f in FACULTies
	join s in STUDENTs
	on f.FID equals s.FID
 

	group s by new {f.FID, f.FLAST, f.FMI, f.FFIRST} into supers
	orderby supers.Key.FLAST ascending
	select new
		{SUPERVISOR = supers.Key.FFIRST + " " + supers.Key.FMI + " " + supers.Key.FLAST,
		Total_Students = supers.Count()};

a2_e.Dump();