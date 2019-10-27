const { PaprikaApi } = require('paprika-api')
const fs = require("fs")

// Ensure that emails and passwords containing $ are escaped with \$
const paprikaApi = new PaprikaApi(
  process.env.PAPRIKA_EMAIL,
  process.env.PAPRIKA_PASSWORD
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
