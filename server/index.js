import express from "express";
import * as mariadb from "mariadb";

const app = express();
app.use(express.json());
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header(
      'Access-Control-Allow-Headers',
      'Origin, X-Requested-With, Content-Type, Accept'
  );
  next();
});

const port = 3000;
let db;

async function connect() {
  console.info("Connecting to DB...");
  db = mariadb.createPool({
    host: process.env["DATABASE_HOST"],
    user: process.env["DATABASE_USER"],
    password: process.env["DATABASE_PASSWORD"],
    database: process.env["DATABASE_NAME"]
  });

  const conn = await db.getConnection();
  try {
    await conn.query("SELECT 1");
  } finally {
    await conn.end();
  }
}

async function main() {
  await connect();

  // Home Route
  app.get("/", (req, res) => {
    res.send("Hello!");
  });

  // Get the labor costs by the  worker
  app.get('/api/v1/labor/worker', async (req, res) => {
    let { status, workerId, locationId } = req.query;
    const queryParams = [];

    // initialize variables for the where claus condition
    let statusCondition = '';
    let workerCondition = '';
    let locationCondition = '';

    /* If there is a status condition passed append this to the where claus condition
       and set the placeholder values to queryParams
    */
    if (status) {
      statusCondition = ' AND t.status = ?';
      queryParams.push(status);
    }

    /* If there is a worker ID or multiple worker ID's requested append these to the where claus condition
       and set the placeholder values to queryParams
   */
    if (workerId) {
      const ids = workerId.split(',');
      workerCondition = ` AND w.id IN (${ids.map(id => '?').join(',')})`;
      queryParams.push(...ids);
    }

   /* If there is a location ID or multiple location ID's requested append these to the where claus condition
      and set the placeholder values to queryParams
   */
    if (locationId) {
      const ids = locationId.split(',');
      locationCondition = ` AND loc.id IN (${ids.map(id => '?').join(',')})`;
      queryParams.push(...ids);
    }

    const query = `
    SELECT w.id AS worker_id, w.username, SUM(lt.time_seconds / 3600 * w.hourly_wage) AS total_labor_cost
    FROM workers w
    JOIN logged_time lt ON w.id = lt.worker_id
    JOIN tasks t ON lt.task_id = t.id
    WHERE 1=1
    ${statusCondition}
    ${workerCondition}
    ${locationCondition}
    GROUP BY w.id;
  `;

    try {
      const result = await db.query(query, queryParams);
      //console.log("========================");
      //console.log({data: result});
      //console.log("========================");
      res.json({data: result});
    } catch (err) {
      console.error(err);
      res.status(500).send('Server error');
    }
  });

// Get the labor costs by workers location
  app.get('/api/v1/labor/location', async (req, res) => {
    let { status, locationId, workerId } = req.query;
    const queryParams = [];

    // initialize variables for the where claus condition
    let statusCondition = '';
    let locationCondition = '';
    let workerCondition = '';

    /* If there is a status condition passed append this to the where claus condition
       and set the placeholder values to queryParams
    */
    if (status) {
      statusCondition = ' AND t.status = ?';
      queryParams.push(status);
    }
    /* If there is a location ID or multiple location ID's requested append these to the where claus condition
       and set the placeholder values to queryParams
    */
    if (locationId) {
      const ids = locationId.split(',');
      locationCondition = ` AND loc.id IN (${ids.map(id => '?').join(',')})`;
      queryParams.push(...ids);
    }
    /* If there is a worker ID or multiple worker ID's requested append these to the where claus condition
       and set the placeholder values to queryParams
    */
    if (workerId) {
      const ids = workerId.split(',');
      workerCondition = ` AND w.id IN (${ids.map(id => '?').join(',')})`;
      queryParams.push(...ids);
    }

    const query = `
    SELECT loc.id AS location_id, loc.name, SUM(lt.time_seconds / 3600 * w.hourly_wage) AS total_labor_cost
    FROM locations loc
    JOIN tasks t ON loc.id = t.location_id
    JOIN logged_time lt ON t.id = lt.task_id
    JOIN workers w ON lt.worker_id = w.id
    WHERE 1=1
    ${statusCondition}
    ${locationCondition}
    ${workerCondition}
    GROUP BY loc.id;
  `;

    try {
      const result = await db.query(query, queryParams);
      //console.log("========================");
      //console.log({data: result});
      //console.log("========================");
      res.json({data: result});
    } catch (err) {
      console.error(err);
      res.status(500).send('Server error');
    }
  });

  app.listen(port, "0.0.0.0", () => {
    console.info(`App listening on ${port}.`);
  });
}

await main();
