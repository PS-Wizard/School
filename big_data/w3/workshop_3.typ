#import "@preview/hetvid:0.1.0": *
#show: hetvid.with(
  title: [Workshop 3 -- MongoDB],
  author: "Swoyam Pokharel",
  affiliation: "Sushil Timilsina",
  header: "Workshop 3",
  // abstract: [Abstract here],
  toc: true,
  body-font: ("Libertinus Serif", "New Computer Modern", "FreeSerif"),
  heading-font: ("New Computer Modern", "Libertinus Serif", "FreeSans"),
  raw-font: ("DejaVu Sans Mono", "JetBrainsMono NF"),
  math-font: "New Computer Modern Math",
  emph-font: ("Libertinus Serif", "New Computer Modern"),
  bib-style: (
    en: "harvard-cite-them-right",
    zh: "gb-7714-2015-numeric",
  ),
)
== Exercise 2.1
Compare how you added the above data and how it differs from INSERT records in a relational database.
In MongoDB, data is inserted as JSON-like documents into collections, so each record can be more flexible in structure and can include fields such as `_id` directly in the document. In a relational database, `INSERT` statements add rows into a fixed table schema with predefined columns and stronger structural constraints.

Add Department 30.
```javascript
db.dept.insertOne({
  _id: 30,
  deptno: 30,
  dname: "SALES",
  loc: "CHICAGO"
})
```
This command adds one new document to the `dept` collection. `insertOne` stores the department details as a single MongoDB document, with each key-value pair becoming a field in that record.

*Output:*
```
{ "acknowledged" : true, "insertedId" : 30 }
```

== Exercise 2.2
Add the employees for Department 30.
```javascript
db.emp.insertMany([
  {
    empno: 7499,
    ename: "ALLEN",
    job: "SALESMAN",
    mgr: 7698,
    hiredate: new Date("1995-02-20"),
    sal: 1600,
    comm: 300,
    deptno: 30
  },
  {
    empno: 7698,
    ename: "BLAKE",
    job: "MANAGER",
    mgr: 7839,
    hiredate: new Date("1981-05-01"),
    sal: 2850,
    deptno: 30
  },
  {
    empno: 7900,
    ename: "JAMES",
    job: "CLERK",
    mgr: 7698,
    hiredate: new Date("1981-12-03"),
    sal: 950,
    deptno: 30
  },
  {
    empno: 7654,
    ename: "MARTIN",
    job: "SALESMAN",
    mgr: 7698,
    hiredate: new Date("1993-09-28"),
    sal: 1250,
    comm: 1400,
    deptno: 30
  },
  {
    empno: 7844,
    ename: "TURNER",
    job: "SALESMAN",
    mgr: 7698,
    hiredate: new Date("1981-09-08"),
    sal: 1500,
    comm: 0,
    deptno: 30
  },
  {
    empno: 7521,
    ename: "WARD",
    job: "SALESMAN",
    mgr: 7698,
    hiredate: new Date("1994-02-22"),
    sal: 1250,
    comm: 500,
    deptno: 30
  }
])
```
This uses `insertMany` to add several employee documents in one operation. Each object in the array becomes its own document, which makes bulk insertion faster and more convenient than adding employees one by one.

*Output:*
```
BulkWriteResult({
  "writeErrors"       : [ ],
  "writeConcernErrors": [ ],
  "nInserted"         : 6,
  "nUpserted"         : 0,
  "nMatched"          : 0,
  "nModified"         : 0,
  "nRemoved"          : 0,
  "upserted"          : [ ]
})
```

== Exercise 2.4
Update the name of department 40 to COMPUTING.
```javascript
db.dept.updateOne(
  { deptno: 40 },
  { $set: { dname: "COMPUTING" } }
)
```
Here, `updateOne` finds the department whose `deptno` is `40`. The `$set` operator changes only the `dname` field, so the rest of the document stays unchanged.

*Output:*
```
{ "acknowledged" : true, "matchedCount" : 1, "modifiedCount" : 1 }
```

We can verify the change with:
```javascript
db.dept.find({ deptno: 40 }).pretty()
```
*Output:*
```
{
  "_id"    : 40,
  "deptno" : 40,
  "dname"  : "COMPUTING",
  "loc"    : "WOLVERHAMPTON"
}
```

Update the salary of employee number 7788 in department 20 to 3500.
```javascript
db.emp.updateOne(
  { empno: 7788, deptno: 20 },
  { $set: { sal: 3500 } }
)
```
This command updates a single employee document by matching both `empno` and `deptno`. Using both conditions makes sure the correct employee is selected, and `$set` replaces the old salary with `3500`.

*Output:*
```
{ "acknowledged" : true, "matchedCount" : 1, "modifiedCount" : 1 }
```

We can verify the change with:
```javascript
db.emp.find({ empno: 7788 }).pretty()
```
*Output:*
```
{
  "_id"     : ObjectId("5a09e79ac536e890d5a7a672"),
  "empno"   : 7788,
  "ename"   : "SCOTT",
  "job"     : "ANALYST",
  "mgr"     : 7566,
  "hiredate": ISODate("2015-10-16T00:00:00Z"),
  "sal"     : 3500,
  "deptno"  : 20
}
```
