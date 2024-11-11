<h1>Movie Explorer</h1>

```js
const movies = await FileAttachment('./data/movies.json').json();

movies.sort((a, b) => a.Oscars - b.Oscars);

movies.forEach(function(d) {
  d.OscarWinner = d.Oscars > 0;
  d.Released = new Date(d.Released);
  d.YearReleased = d.Released.getFullYear();
  d.Genres = d.Genre?.split(',').map(s => s.trim()) || [];
  d.Director = d.Director?.toLowerCase() || '';
  d.Cast = d.Cast?.toLowerCase() || '';
});

const genres = Array.from(
  movies.reduce(function(set, d) {
    d.Genres.forEach(g => set.add(g));
    return set;
  }, new Set())
)
.sort((a, b) => a.localeCompare(b));

const yearExtent = d3.extent(movies, d => d.YearReleased);
const oscarsExtent = d3.extent(movies, d => d.Oscars);
```

```js
const gy = 150;
const getGrey = opacity => `rgba(${gy},${gy},${gy},${opacity})`;

const getWonOscarText = bool => bool ? 'Won Oscar(s)' : 'Didn\'t Win an Oscar';

const axisVariables = [
  {name: 'Tomatometer', prop: 'Meter'},
  {name: 'Numeric Rating', prop: 'Rating'},
  {name: 'Number of Reviews', prop: 'Reviews'},
  {name: 'Box-office revenue ($million)', prop: 'BoxOffice'},
  {name: 'Year', prop: 'Released'},
  {name: 'Length (minutes)', prop: 'Runtime'},
];
```

```js
const xVariable = view(
  Inputs.select(axisVariables, {
    label: 'X-axis Variable',
    format: d => d.name,
    value: axisVariables.find((d) => d.prop === 'Meter')
  })
);

const yVariable = view(
  Inputs.select(axisVariables, {
    label: 'Y-axis Variable',
    format: d => d.name,
    value: axisVariables.find((d) => d.prop === 'Reviews')
  })
);

const reviewsMin = view(
  Inputs.range(
    [10, 300],
    { label: 'Minimum number of reviews on Rotten Tomatoes', step: 1, value: 80 }
  )
);

const yearMin = view(
  Inputs.number(
    yearExtent,
    { label: 'Earliest release year', step: 1, value: 1970 }
  )
);

const yearMax = view(
  Inputs.number(
    yearExtent,
    { label: 'Latest release year', step: 1, value: yearExtent[1] }
  )
);

const dollarsMin = view(
  Inputs.number(
    [0, 800],
    { label: 'Minimum box-office revenue ($million)', step: 10, value: 0 }
  )
);

const dollarsMax = view(
  Inputs.number(
    [0, 800],
    { label: 'Maximum box-office revenue ($million)', step: 10, value: 800 }
  )
);

const oscarsMin = view(
  Inputs.range(
    oscarsExtent,
    { label: 'Minimum number of Oscars won', step: 1, value: 0 }
  )
)

const selectedGenre = view(
  Inputs.select(['All'].concat(genres), {
    label: 'Genre',
    value: 'All'
  })
);

const directorText = view(
  Inputs.text({
    label: 'Director name contains',
    value: ''
  })
);

const castText = view(
  Inputs.text({
    label: 'Cast contains',
    value: ''
  })
);
```
