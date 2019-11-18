const { PaprikaApi } = require('paprika-api')
const fs = require("fs")

if(process.argv.length !== 4) {
  throw `
    fetch-groceries.js script called with incorrect number of arguments.
    Include username and password.
  `
}

// Ensure that emails and passwords containing $ are escaped with \$
const paprikaApi = new PaprikaApi(
  process.argv[2], // username / email
  process.argv[3] // password
)

return paprikaApi.groceries().then(groceries => {
  fs.writeFile(
    "./tmp/groceries.json",
    JSON.stringify(groceries, null, 2),
    (err) => {
      if (err) {
        console.error(err);
        return;
      };
      console.log("Grocery json successfully fetched from Paprika");
    }
  );
})
